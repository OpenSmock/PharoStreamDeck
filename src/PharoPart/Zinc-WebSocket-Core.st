ConnectionClosed subclass: #ZnWebSocketClosed
	instanceVariableNames: 'code reason'
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketClosed commentStamp: '<historical>' prior: 0!
I am ZnWebSocketClosed, signalled when WebSocket close frame is received.
I am a ConnectionClosed and a NetworkError.

Part of Zinc HTTP Components.
!


!ZnWebSocketClosed methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
code
	^ code! !

!ZnWebSocketClosed methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
code: anObject
	code := anObject! !

!ZnWebSocketClosed methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
reason
	^ reason! !

!ZnWebSocketClosed methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
reason: anObject
	reason := anObject! !


ZnResponse subclass: #ZnWebSocketResponse
	instanceVariableNames: 'continuation'
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketResponse commentStamp: '<historical>' prior: 0!
I am ZnWebSocketResponse used to continue the WebSocket conversation after the connection upgrade.
I am a ZnResponse.

Part of Zinc HTTP Components.!


!ZnWebSocketResponse methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
continuation
	"Return the block that represents the continuation 
	when the server call #useConnection: on me.
	The block will be evaluated with an instanciated WebSocket."

	^ continuation! !

!ZnWebSocketResponse methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
useConnection: connection
	"Hook method overwritten to give the receiver the chance to 
	keep using connection in the current thread/process after the server wrote the response.
	We start a conversation by instanciating a WebSocket and passing it to our continuation."
	
	| webSocket |
	webSocket := ZnWebSocket onStream: connection.
	self continuation value: webSocket! !


!ZnWebSocketResponse methodsFor: 'initialize-release' stamp: '8/31/2024 11:18:34'!
continuation: block
	"Set the block that represents the continuation 
	when the server call #useConnection: on me.
	The block will be evaluated with an instanciated WebSocket."
	
	continuation := block! !


!ZnWebSocketResponse methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
wantsConnectionClose
	"After we are done, the server can close the connection we were using"
	 
	^ true! !


Object subclass: #ZnWebSocket
	instanceVariableNames: 'stream role'
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocket commentStamp: '<historical>' prior: 0!
I am ZnWebSocket, a bi-directional, full-duplex communication channel over a single TCP connection.

WebSockets send reliable messages to each other, a String or ByteArrat.
Each message is one-way (does not have a direct synchroneous reply). 
Each party, both client and/or server can take the initiative.

This implementation follows RFC 6455. See also:

	http://en.wikipedia.org/wiki/Websockets
	http://tools.ietf.org/html/rfc6455

Here is a client side example taking to a public echo service: 

| webSocket |
webSocket := ZnWebSocket to: 'ws://echo.websocket.org'.
[ webSocket 
	sendMessage: 'Pharo Smalltalk using Zinc WebSockets !!';
	readMessage ] ensure: [ webSocket close ].

Here is the same example using secure web sockets:

| webSocket |
webSocket := ZnWebSocket to: 'wss://echo.websocket.org'.
[ webSocket 
	sendMessage: 'Pharo Smalltalk using Zinc WebSockets & Zodiac !!';
	readMessage ] ensure: [ webSocket close ].

Here is how to start a local server running in the image implementing the same echo service:

ZnWebSocket startServerOn: 8080 do: ZnWebSocketEchoHandler new.

A full inline implementation of the echo handler would look like:

ZnWebSocket 
	startServerOn: 8080 
	do: [ :webSocket | 
		[ 
			webSocket runWith: [ :message |
				self crLog: 'Received message: ', message printString, ' echoing...'.
				webSocket sendMessage: message ] ] 
			on: ConnectionClosed 
			do: [ self crLog: 'Ignoring connection close, done' ] ].

Part of Zinc HTTP Components.!


!ZnWebSocket methodsFor: 'initialize-release' stamp: '8/31/2024 11:18:34'!
close
	"Send a close frame and close the connection"

	self sendFrame: ZnWebSocketFrame close.
	stream close.! !

!ZnWebSocket methodsFor: 'initialize-release' stamp: '8/31/2024 11:18:34'!
initialize
	super initialize.
	role := #server! !

!ZnWebSocket methodsFor: 'initialize-release' stamp: '8/31/2024 11:18:34'!
onStream: socketStream
	"Initialize the receiver on socketStream"
	
	stream := socketStream ! !

!ZnWebSocket methodsFor: 'initialize-release' stamp: '8/31/2024 11:18:34'!
role: symbol
	"Set the role of the receiver, either #client or #server"
	
	self assert: (#(client server) includes: symbol).
	role := symbol! !


!ZnWebSocket methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
handleControlFrame: frame
	"Handle a control frame. ConnectionClosed is signalled when the other end closes."
	
	frame isClose 
		ifTrue: [ 
			self logControlFrameHandled: #close.
			self close. 
			^ self signalClosed: frame ].
	frame isPing 
		ifTrue: [ 
			self logControlFrameHandled: #ping.
			self pong: frame body ].
	frame isPong 
		ifTrue: [
			self logControlFrameHandled: #pong ]! !

!ZnWebSocket methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
logControlFrameHandled: type
	ZnWebSocketControlFrameHandledEvent new
		type: type;
		emit! !

!ZnWebSocket methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
pong: payload
	"Send a pong frame containing payload (in reply to a ping with that payload)"
	
	| frame |
	frame := ZnWebSocketFrame pong: payload.
	self sendFrame: frame ! !

!ZnWebSocket methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
readFrame
	"Read and return the next non-control frame. Wait.
	Control frames are handled. ConnectionClosed is signalled when the other end closes."
	
	| frame |
	frame := ZnWebSocketFrame readFrom: stream.
	frame isControl 
		ifTrue: [
			self handleControlFrame: frame.
			^ self readFrame ].
	^ frame! !

!ZnWebSocket methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
sendBytes: bytes
	"Send bytes in one binary frame"

	| frame |
	frame := ZnWebSocketFrame bytes: bytes.
	self sendFrame: frame! !

!ZnWebSocket methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
sendFrame: frame
	"Send a single frame, masked when I am in a client role, flush"
	
	frame masked: self isClient.
	frame writeOn: stream.
	stream flush.! !

!ZnWebSocket methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
sendText: string
	"Send string in one textual frame"

	| frame |
	frame := ZnWebSocketFrame text: string.
	self sendFrame: frame! !

!ZnWebSocket methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
signalClosed: frame
	"Turn a close frame that we received into a ZnWebSocketClosed exception and signal it."
	
	| exception |
	exception := ZnWebSocketClosed new.
	frame isEmpty 
		ifFalse: [
			exception 
				code: frame closeCode;
				reason: frame closeReason ].
	exception signal.! !


!ZnWebSocket methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
handleControlFrameNoWait
	"Peek for a control frame if any and handle it. Do not wait.
	Return true when a control frame was handled, false otherwise."
	
	(stream isDataAvailable and: [ (stream peek bitAnd: 127) > 7 ])
		ifTrue: [ | frame |
			frame := ZnWebSocketFrame readFrom: stream.
			self handleControlFrame: frame.
			^ true ].
	^ false! !

!ZnWebSocket methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
ping
	"Send a generic ping (with an empty payload).
	Ping messages are sent automatically from #runWith: as a keep alive
	whenever the connection times out and loops. 
	The interval is thus the connection's read time out"
	
	self pingEmpty! !

!ZnWebSocket methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
ping: payload
	"Send a ping frame with payload"

	| frame |
	frame := ZnWebSocketFrame ping: payload.
	self sendFrame: frame! !

!ZnWebSocket methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
pingEmpty
	"Send a ping with an empty payload."

	self ping: #[ ]! !

!ZnWebSocket methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
pingRandom
	"Send a ping with a 4-byte random payload."

	self ping: ZnWebSocketUtils newPingPayload! !

!ZnWebSocket methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
readMessage
	"Read and return a complete message String or ByteArray, joining frames. 
	ConnectionClosed is signalled when the other end closes."
	
	| frame bytes isText |
	frame := self readFrame.
	frame isFinal ifTrue: [ ^ frame contents ].
	isText := frame isText.
	bytes := ByteArray new: frame size * 2 streamContents: [ :output |
		frame writeRawBodyOn: output.
		[ 
			frame := self readFrame.
			self assert: frame isContinuation. 
			frame writeRawBodyOn: output.
			frame isFinal ] whileFalse ].
	^ isText 
		ifTrue: [ ZnUTF8Encoder new decodeBytes: bytes ]
		ifFalse: [ bytes ]! !

!ZnWebSocket methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
runWith: block
	"Start a run loop handling the WebSocket protocol.
	When a message is received, block will be passed a String or ByteArray.
	ConnectionClosed will be signalled when the other end closes."
	
	[ | message |
		message := nil.
		[ message := self readMessage ] 
			on: ConnectionTimedOut 
			do: [ "Ignore & continue" self ping ].
		message ifNotNil: [
			block value: message ] ] repeat! !

!ZnWebSocket methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
sendByteFrames: sequenceableCollection
	"Send a binary message consisting of sequenceableCollection byte array frames"

	| frame |
	self assert: sequenceableCollection size > 1.
	(frame := ZnWebSocketFrame bytes: sequenceableCollection first)
		final: false.
	self sendFrame: frame.
	2 to: sequenceableCollection size - 1 do: [ :each |
		(frame := ZnWebSocketFrame bytes: (sequenceableCollection at: each))
			final: false; opcode: 0.
		self sendFrame: frame ].
	(frame := ZnWebSocketFrame bytes: sequenceableCollection last)
		final: true; opcode: 0.
	self sendFrame: frame
	! !

!ZnWebSocket methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
sendMessage: stringOrByteArray
	"Send stringOrByteArray in one textual or binary frame"

	stringOrByteArray isString
		ifTrue: [ self sendText: stringOrByteArray ] 
		ifFalse: [ self sendBytes: stringOrByteArray ]! !

!ZnWebSocket methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
sendTextFrames: sequenceableCollection
	"Send a textual message consisting of sequenceableCollection string frames"

	| frame |
	self assert: sequenceableCollection size > 1.
	(frame := ZnWebSocketFrame text: sequenceableCollection first)
		final: false.
	self sendFrame: frame.
	2 to: sequenceableCollection size - 1 do: [ :each |
		(frame := ZnWebSocketFrame text: (sequenceableCollection at: each))
			final: false; opcode: 0.
		self sendFrame: frame ].
	(frame := ZnWebSocketFrame text: sequenceableCollection last)
		final: true; opcode: 0.
	self sendFrame: frame
	! !


!ZnWebSocket methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isClient
	"Return true if the receiver is the client in a WebSocket conversation"
	
	^ role = #client! !

!ZnWebSocket methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isConnected
	"Return true when I am connected, 
	i.e. not closed and still connected at the socket level"

	^ stream notNil and: [ stream isConnected ]! !

!ZnWebSocket methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isServer
	"Return true if the receiver is the server in a WebSocket conversation"

	^ role = #server! !


!ZnWebSocket methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
logGeneric: subject
	ZnWebSocketGenericLogEvent new
		subject: subject;
		emit! !

!ZnWebSocket methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
role
	"Return the role of the receiver, either #client or #server"
	
	^ role! !

!ZnWebSocket methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
stream
	^ stream! !


!ZnWebSocket methodsFor: 'printing' stamp: '8/31/2024 11:18:34'!
printOn: aStream
	super printOn: aStream.
	aStream 
		nextPut: $(; 
		print: role;
		nextPut: $)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZnWebSocket class
	instanceVariableNames: ''!
!ZnWebSocket class commentStamp: '<historical>' prior: 0!
I am ZnWebSocket, a bi-directional, full-duplex communication channel over a single TCP connection.

WebSockets send reliable messages to each other, a String or ByteArrat.
Each message is one-way (does not have a direct synchroneous reply). 
Each party, both client and/or server can take the initiative.

This implementation follows RFC 6455. See also:

	http://en.wikipedia.org/wiki/Websockets
	http://tools.ietf.org/html/rfc6455

Here is a client side example taking to a public echo service: 

| webSocket |
webSocket := ZnWebSocket to: 'ws://echo.websocket.org'.
[ webSocket 
	sendMessage: 'Pharo Smalltalk using Zinc WebSockets !!';
	readMessage ] ensure: [ webSocket close ].

Here is the same example using secure web sockets:

| webSocket |
webSocket := ZnWebSocket to: 'wss://echo.websocket.org'.
[ webSocket 
	sendMessage: 'Pharo Smalltalk using Zinc WebSockets & Zodiac !!';
	readMessage ] ensure: [ webSocket close ].

Here is how to start a local server running in the image implementing the same echo service:

ZnWebSocket startServerOn: 8080 do: ZnWebSocketEchoHandler new.

A full inline implementation of the echo handler would look like:

ZnWebSocket 
	startServerOn: 8080 
	do: [ :webSocket | 
		[ 
			webSocket runWith: [ :message |
				self crLog: 'Received message: ', message printString, ' echoing...'.
				webSocket sendMessage: message ] ] 
			on: ConnectionClosed 
			do: [ self crLog: 'Ignoring connection close, done' ] ].

Part of Zinc HTTP Components.!


!ZnWebSocket class methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
isValidWebSocketResponse: client
	"Return true when client contains a valid WebSocket response for its WebSocket request"

	| acceptKey response |
	acceptKey := ZnWebSocketUtils handshake: (client request headers at: 'Sec-WebSocket-Key').
	response := client response.
	^ response code = 101
		and: [
			(response headers at: 'Upgrade') asLowercase = 'websocket' 
				and: [
					(ZnWebSocketUtils containsConnectionUpgrade: response headers)
						and: [ 
							(response headers at: 'Sec-WebSocket-Accept') = acceptKey ] ] ]! !

!ZnWebSocket class methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
webSocketClientTo: url
	"Create and return a new ZnClient instance ready for the initial client side WebSocket setup request"
	
	| client |
	self assert: (#(ws wss) includes: url scheme).
	(client := ZnClient new)
		url: url;
		method: #GET;
		headerAt: 'Upgrade' put: 'websocket';
		headerAt: 'Connection' put: 'Upgrade';
		headerAt: 'Sec-WebSocket-Version' put: '13';
		headerAt: 'Sec-WebSocket-Key' put: ZnWebSocketUtils newClientKey.
	^ client   
	! !


!ZnWebSocket class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
onClient: client
	"Create and return a functioning ZnWebSocket object based on an HTTP client,
	assuming the initial upgrade handshake was executed. The validity of the response is checked.
	Signals a ZnWebSocketFailed error when unsuccessful."

	(self isValidWebSocketResponse: client)
		ifTrue: [
			^ (self onStream: client connection)
				role: #client;
				yourself ]
		ifFalse: [
			client close.
			(ZnWebSocketFailed response: client response) signal ]! !

!ZnWebSocket class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
onStream: socketStream
	"Return a new ZnWebSocket instance on socketStream.
	It is assumed that the initial handshake was successful."
	
	^ self new
		onStream: socketStream;
		yourself! !

!ZnWebSocket class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
startServerOn: port do: handler
	"Start and return a new ZnServer listening on port and / for client WebSocket connections.
	After a successful initial handshake, sent #value: to handler with a server side ZnWebSocket instance."
	
	^ self startServerOn: port prefix: '' do: handler  ! !

!ZnWebSocket class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
startServerOn: port prefix: prefix do: handler
	"Start and return a new ZnServer listening on port and /prefix for client WebSocket connections.
	After a successful initial handshake, sent #value: to handler with a server side ZnWebSocket instance."
	
	^ (ZnServer on: port)
		delegate: (ZnWebSocketDelegate map: prefix to: handler);
		start;
		yourself! !

!ZnWebSocket class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
to: urlObject
	"Attempt to create a new client WebSocket to urlObject.
	Do the initial upgrade handshake and return a functioning ZnWebSocket object.
	Signals a ZnWebSocketFailed error when unsuccessful."

	^ self to: urlObject config: [ :httpClient | ]! !

!ZnWebSocket class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
to: urlObject config: block
	"Attempt to create a new client WebSocket to urlObject.
	Execute block to further configure the HTTP client before the upgrade request.
	Do the initial upgrade handshake and return a functioning ZnWebSocket object.
	Signals a ZnWebSocketFailed error when unsuccessful."

	| client |
	client := self webSocketClientTo: urlObject asZnUrl.
	block value: client.
	client execute.
	^ self onClient: client! !


Object subclass: #ZnWebSocketUtils
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketUtils commentStamp: '<historical>' prior: 0!
I am ZnWebSocketUtils.

Part of Zinc HTTP Components.!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZnWebSocketUtils class
	instanceVariableNames: ''!
!ZnWebSocketUtils class commentStamp: '<historical>' prior: 0!
I am ZnWebSocketUtils.

Part of Zinc HTTP Components.!


!ZnWebSocketUtils class methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
containsConnectionUpgrade: headers
	^ (((headers at: 'Connection' ifAbsent: [ ^ false ]) 
			findTokens: ',') 
				collect: [ :each | each trimBoth asLowercase ]) 
					includes: 'upgrade'! !

!ZnWebSocketUtils class methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
newMask
	^ self randomByteArrayOfSize: 4! !

!ZnWebSocketUtils class methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
newPingPayload
	^ self randomByteArrayOfSize: 4! !

!ZnWebSocketUtils class methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
randomByteArrayOfSize: size
	^ ByteArray new: size streamContents: [ :stream |
		size timesRepeat: [ 
			stream nextPut: 256 atRandom - 1 ] ].
! !


!ZnWebSocketUtils class methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
handshake: clientKey
	"Perform the WebSocket key handshake"
	
	"self handshake: 'dGhlIHNhbXBsZSBub25jZQ=='"
	
	| string hash |
	string := clientKey, self serverGUID.
	hash := SHA1 hashMessage: string.
	^ ZnUtils encodeBase64: hash! !

!ZnWebSocketUtils class methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
newClientKey
	"Generate a new WebSocket client key"
	
	| rawKey |
	rawKey := self randomByteArrayOfSize: 16.
	^ ZnUtils encodeBase64: rawKey! !


!ZnWebSocketUtils class methodsFor: 'constants' stamp: '8/31/2024 11:18:34'!
serverGUID
	"This is the special WebSocket server GUID"
	
	^ '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'! !


Object subclass: #ZnWebSocketStatusHandler
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketStatusHandler commentStamp: '<historical>' prior: 0!
I am ZnWebSocketStatusHandler, emitting some Smalltalk image status data every second as a stream of WebSocket messages.

See the class comment of ZnWebSocketDelegate for an example using ZnWebSocketStatusHandler.

Part of Zinc HTTP Components.!


!ZnWebSocketStatusHandler methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
processes
	| allProcesses |
	allProcesses := (Process allSubInstances
		reject: [ :each | each isTerminated or: [ each = Processor activeProcess ] ])
			sorted: [ :a :b | a priority >= b priority ].
	^ String streamContents: [ :out |
		allProcesses doWithIndex: [ :each :index |
			out 
				print: index; nextPut: $.; space; 
				nextPutAll: each name; space;
				nextPut: $[; print: each priority; nextPut: $]; space;
				print: each; cr ] ]! !

!ZnWebSocketStatusHandler methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
status
	^ String cr join: { 
		DateAndTime now printString. 
		self systemVersionInfo. 
		self vmStats. 
		self processes }
! !

!ZnWebSocketStatusHandler methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
systemVersionInfo
	^ String streamContents: [ :stream |
			stream 
				print: SystemVersion current; 
				nextPutAll: ' - '; 
				nextPutAll: ZnConstants defaultServerString ]! !

!ZnWebSocketStatusHandler methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
value: webSocket
	"I stream status messages to a WebSocket client, once every second 
	until ConnectionClosed or no longer isConnected"
	
	[ 
		webSocket logGeneric: 'Started status streaming'.
		[ 
			webSocket sendMessage: self status.
			1 second asDelay wait.
			webSocket isConnected ] whileTrue ] 
		on: NetworkError  
		do: [ webSocket logGeneric: 'Ignoring network error' ].
	webSocket logGeneric: 'Stopping status streaming' ! !

!ZnWebSocketStatusHandler methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
vmStats
	^ SmalltalkImage current vm statisticsReport! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZnWebSocketStatusHandler class
	instanceVariableNames: ''!
!ZnWebSocketStatusHandler class commentStamp: '<historical>' prior: 0!
I am ZnWebSocketStatusHandler, emitting some Smalltalk image status data every second as a stream of WebSocket messages.

See the class comment of ZnWebSocketDelegate for an example using ZnWebSocketStatusHandler.

Part of Zinc HTTP Components.!


!ZnWebSocketStatusHandler class methodsFor: 'constants' stamp: '8/31/2024 11:18:34'!
clientHtml
	^ '<!!DOCTYPE html>
<meta charset="utf-8" />
<title>WebSocket Smalltalk Image Status Stream</title>

<script language="javascript" type="text/javascript">

  var wsUri = "ws://" + location.host + "/ws-status";
  var output, statusElement;

  function init() {
    output = document.getElementById("output");
    statusElement = document.getElementById("status");
    testWebSocket();
  }

  function testWebSocket() {
    writeToScreen(wsUri);
    websocket = new WebSocket(wsUri);
    websocket.onopen = function(evt) { onOpen(evt) };
    websocket.onclose = function(evt) { onClose(evt) };
    websocket.onmessage = function(evt) { onMessage(evt) };
    websocket.onerror = function(evt) { onError(evt) };
  }

  function onOpen(evt) {
    writeToScreen("CONNECTED");
    setStatus("Waiting for status data...");
   }

  function onClose(evt) {
    writeToScreen("DISCONNECTED");
  }

  function onMessage(evt) {
    setStatus(evt.data);
  }

  function onError(evt) {
    writeToScreen("<span style=''color: red''>ERROR:</span> " + evt.data);
  }

  function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
  }

  function setStatus(text) {
    statusElement.innerHTML = text;
  }

  window.addEventListener("load", init, false);

</script>

<h2>WebSocket Smalltalk Image Status Stream</h2>
<div><pre id="status"></pre></div>
<h3>Log</h3>
<div id="output"></div>

</html> '! !


Object subclass: #ZnWebSocketChatroomHandler
	instanceVariableNames: 'webSockets lock'
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketChatroomHandler commentStamp: '<historical>' prior: 0!
I am ZnWebSocketChatroomHandler, I send a copy of each incoming message over a WebSocket to all WebSockets currently open, thus implementing a simple chat room.

See the class comment of ZnWebSocketDelegate for an example using ZnWebSocketChatroomHandler.

Part of Zinc HTTP Components.!


!ZnWebSocketChatroomHandler methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
distributeMessage: message 
	"Send message to all client WebSockets that we know."
	
	lock critical: [
		webSockets do: [ :each |
			[ each sendMessage: message ]
				on: NetworkError 
				do: [ :exception |
					"We can ignore this (instead of #unregister:-ing the offender), 
					since the listener process (see #value:) will do the right thing" 
					each logGeneric: exception printString, ' in ditributeMessage, ignoring' ] ] ]! !

!ZnWebSocketChatroomHandler methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
register: clientWebSocket
	lock critical: [
		webSockets add: clientWebSocket ]! !

!ZnWebSocketChatroomHandler methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
unregister: clientWebSocket
	lock critical: [
		webSockets remove: clientWebSocket ifAbsent: [ ] ]! !


!ZnWebSocketChatroomHandler methodsFor: 'initialize-release' stamp: '8/31/2024 11:18:34'!
initialize
	webSockets := OrderedCollection new.
	lock := Mutex new! !


!ZnWebSocketChatroomHandler methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
value: webSocket
	"I implement a simple chat room service as a server:
	distributing incoming messages to all known clients"
	
	[
		self register: webSocket.
		webSocket runWith: [ :message |
			webSocket logGeneric: 'Received message: ', message printString.
			self distributeMessage: message ] ] 
		on: NetworkError 
		do: [
			webSocket logGeneric: 'Network error, cleaning up'.
			self unregister: webSocket ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZnWebSocketChatroomHandler class
	instanceVariableNames: ''!
!ZnWebSocketChatroomHandler class commentStamp: '<historical>' prior: 0!
I am ZnWebSocketChatroomHandler, I send a copy of each incoming message over a WebSocket to all WebSockets currently open, thus implementing a simple chat room.

See the class comment of ZnWebSocketDelegate for an example using ZnWebSocketChatroomHandler.

Part of Zinc HTTP Components.!


!ZnWebSocketChatroomHandler class methodsFor: 'constants' stamp: '8/31/2024 11:18:34'!
clientHtml
	^ '<!!DOCTYPE html>
<meta charset="utf-8" />
<title>WebSocket Chatroom</title>

<script language="javascript" type="text/javascript">

  var wsUri = "ws://" + location.host + "/ws-chatroom";
  var websocket;
  var output, handleInput, messageInput, sendButton, closeButton;

  function init() {
    output = document.getElementById("output");
    handleInput = document.getElementById("handleInput");
    messageInput = document.getElementById("messageInput");
    sendButton = document.getElementById("sendButton");
    closeButton = document.getElementById("closeButton");
    handleInput.value = "user-" + (new Date()).getMilliseconds();
    messageInput.onkeyup = function (evt) { if (evt.keyCode == 13) sendChatMessage(evt) }
    sendButton.onclick = function (evt) { sendChatMessage(evt) };
    closeButton.onclick = function (evt) { closeChat(evt) };
    testWebSocket();
  }

  function testWebSocket() {
    writeToScreen(wsUri);
    websocket = new WebSocket(wsUri);
    websocket.onopen = function(evt) { onOpen(evt) };
    websocket.onclose = function(evt) { onClose(evt) };
    websocket.onmessage = function(evt) { onMessage(evt) };
    websocket.onerror = function(evt) { onError(evt) };
  }

  function onOpen(evt) {
    writeToScreen("CONNECTED");
    doSend("Hi there !!");
  }

  function onClose(evt) {
    writeToScreen("DISCONNECTED");
  }

  function onMessage(evt) {
    writeToScreen(evt.data);
   }

  function onError(evt) {
    writeToScreen("<span style=''color: red''>ERROR:</span> " + evt.data);
  }

  function doSend(message) {
     websocket.send(handleInput.value + ">>" + message);
  }

  function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
  }

  function sendChatMessage(evt) {
    doSend(messageInput.value);
    messageInput.value = "";
  }

  function closeChat(evt) {
    doSend("Bye!!");
    websocket.close();
  }

  window.addEventListener("load", init, false);

</script>

<h2>WebSocket Chatroom</h2>
<div>
Handle: <input id="handleInput" type="text"/>
Message: <input id="messageInput" type="text" size="64"/> 
<input id="sendButton" type="submit" value="Send"/>
<input id="closeButton" type="submit" value="Close"/>
</div>
<div id="output"></div>

</html> '
! !


Object subclass: #ZnWebSocketEchoHandler
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketEchoHandler commentStamp: '<historical>' prior: 0!
I am ZnWebSocketEchoHandler, implementing an echo service conversation as a WebSocket server: reading messages and echoing them back until ConnectionClosed.

See the class comment of ZnWebSocketDelegate for an example using ZnWebSocketEchoHandler.

Part of Zinc HTTP Components.!


!ZnWebSocketEchoHandler methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
value: webSocket
	"I implement an echo service conversation as a server:
	reading messages and echoing them back until ConnectionClosed"
	
	[ 
		webSocket runWith: [ :message |
			webSocket logGeneric: 'Received message: ', message printString, ', echoing'.
			webSocket sendMessage: message ] ] 
		on: ConnectionClosed 
		do: [ webSocket logGeneric: 'Ignoring connection close, done' ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZnWebSocketEchoHandler class
	instanceVariableNames: ''!
!ZnWebSocketEchoHandler class commentStamp: '<historical>' prior: 0!
I am ZnWebSocketEchoHandler, implementing an echo service conversation as a WebSocket server: reading messages and echoing them back until ConnectionClosed.

See the class comment of ZnWebSocketDelegate for an example using ZnWebSocketEchoHandler.

Part of Zinc HTTP Components.!


!ZnWebSocketEchoHandler class methodsFor: 'constants' stamp: '8/31/2024 11:18:34'!
clientHtml
	^ '<!!DOCTYPE html>
<meta charset="utf-8" />
<title>WebSocket Test</title>

<script language="javascript" type="text/javascript">

  var wsUri = "ws://" + location.host + "/ws-echo";
  var output;

  function init() {
    output = document.getElementById("output");
    testWebSocket();
  }

  function testWebSocket() {
    writeToScreen(wsUri);
    websocket = new WebSocket(wsUri);
    websocket.onopen = function(evt) { onOpen(evt) };
    websocket.onclose = function(evt) { onClose(evt) };
    websocket.onmessage = function(evt) { onMessage(evt) };
    websocket.onerror = function(evt) { onError(evt) };
  }

  function onOpen(evt) {
    writeToScreen("CONNECTED");
    doSend("WebSocket rocks");
  }

  function onClose(evt) {
    writeToScreen("DISCONNECTED");
  }

  function onMessage(evt) {
    writeToScreen("<span style=''color: blue;''>RESPONSE: " + evt.data+"</span>");
    websocket.close();
  }

  function onError(evt) {
    writeToScreen("<span style=''color: red''>ERROR:</span> " + evt.data);
  }

  function doSend(message) {
    writeToScreen("SENT: " + message); 
    websocket.send(message);
  }

  function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
  }

  window.addEventListener("load", init, false);

</script>

<h2>WebSocket Test</h2>
<div id="output"></div>

</html> '! !

!ZnWebSocketEchoHandler class methodsFor: 'constants' stamp: '8/31/2024 11:18:34'!
clientHtmlRemote
	^ '<!!DOCTYPE html>
<meta charset="utf-8" />
<title>WebSocket Test</title>

<script language="javascript" type="text/javascript">

  var wsUri = "ws://echo.websocket.org";
  var output;

  function init() {
    output = document.getElementById("output");
    testWebSocket();
  }

  function testWebSocket() {
    writeToScreen(wsUri);
    websocket = new WebSocket(wsUri);
    websocket.onopen = function(evt) { onOpen(evt) };
    websocket.onclose = function(evt) { onClose(evt) };
    websocket.onmessage = function(evt) { onMessage(evt) };
    websocket.onerror = function(evt) { onError(evt) };
  }

  function onOpen(evt) {
    writeToScreen("CONNECTED");
    doSend("WebSocket rocks");
  }

  function onClose(evt) {
    writeToScreen("DISCONNECTED");
  }

  function onMessage(evt) {
    writeToScreen("<span style=''color: blue;''>RESPONSE: " + evt.data+"</span>");
    websocket.close();
  }

  function onError(evt) {
    writeToScreen("<span style=''color: red''>ERROR:</span> " + evt.data);
  }

  function doSend(message) {
    writeToScreen("SENT: " + message); 
    websocket.send(message);
  }

  function writeToScreen(message) {
    var pre = document.createElement("p");
    pre.style.wordWrap = "break-word";
    pre.innerHTML = message;
    output.appendChild(pre);
  }

  window.addEventListener("load", init, false);

</script>

<h2>WebSocket Test</h2>
<div id="output"></div>

</html> '! !


Error subclass: #ZnWebSocketFailed
	instanceVariableNames: 'response'
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketFailed commentStamp: '<historical>' prior: 0!
I am ZnWebSocketFailed, an exception thrown when a client WebSocket cannot be created successfully.
I am an Error.

Part of Zinc HTTP Components. !


!ZnWebSocketFailed methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
response
	^ response! !

!ZnWebSocketFailed methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
response: anObject
	response := anObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZnWebSocketFailed class
	instanceVariableNames: ''!
!ZnWebSocketFailed class commentStamp: '<historical>' prior: 0!
I am ZnWebSocketFailed, an exception thrown when a client WebSocket cannot be created successfully.
I am an Error.

Part of Zinc HTTP Components. !


!ZnWebSocketFailed class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
response: response
	^ self new
		response: response;
		yourself! !


Object subclass: #ZnWebSocketDelegate
	instanceVariableNames: 'prefix handler'
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketDelegate commentStamp: '<historical>' prior: 0!
I am ZnWebSocketDelegate, a plugin to allow a ZnServer to accept incoming WebSocket requests.

When accepted, the request is upgraded and a new WebSocket is created and handed to the handler block.

Here is how to get 3 examples up and running:

	ZnServer startDefaultOn: 1701.
	ZnServer default logToTranscript.
	ZnWebSocketDelegate installExamplesInDefaultServer.
	ZnServer stopDefault.

Part of Zinc HTTP Components.!


!ZnWebSocketDelegate methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
continuation
	"Return a block that defines what happens after a successful connection upgrade.
	We will receive a ready-to-use instanciated WebSocket.
	We delegate processing to our handler."

	^ [ :webSocket | self handler value: webSocket ]! !

!ZnWebSocketDelegate methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
isValidWebSocketRequest: request
	"Return true when request can be considered a valid WebSocket setup request"
	
	^ request method = #GET
			and: [ (request headers at: 'Upgrade' ifAbsent: [ ^ false ]) asLowercase = 'websocket' 
				and: [ (ZnWebSocketUtils containsConnectionUpgrade: request headers) 
					and: [ (request headers at: 'Sec-WebSocket-Version' ifAbsent: [ ^ false ]) = '13'
						and: [ request headers includesKey: 'Sec-WebSocket-Key' ] ] ] ]! !

!ZnWebSocketDelegate methodsFor: 'protocol' stamp: '8/31/2024 11:18:34'!
webSocketResponseForRequest: request
	"Given a valid WebSocket setup request, return the matching server response"
	
	| acceptKey |
	acceptKey := ZnWebSocketUtils handshake: (request headers at: 'Sec-WebSocket-Key').
	^ ZnWebSocketResponse new
		statusLine: (ZnStatusLine code: 101);
		headers: (self responseHeadersForKey: acceptKey);
		continuation: self continuation;
		yourself
		! !


!ZnWebSocketDelegate methodsFor: 'public' stamp: '8/31/2024 11:18:34'!
handleRequest: request
	"Server delegate entry point"
	
	(prefix isNil or: [ prefix = request uri pathSegments ])
		ifFalse: [ ^ ZnResponse notFound: request uri ].
	^ (self isValidWebSocketRequest: request)
			ifTrue: [ self webSocketResponseForRequest: request ]
			ifFalse: [ ZnResponse badRequest: request ]! !

!ZnWebSocketDelegate methodsFor: 'public' stamp: '8/31/2024 11:18:34'!
value: request
	"I implement the generic #value: message as equivalent to #handleRequest:"
	
	^ self handleRequest: request! !


!ZnWebSocketDelegate methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
handler
	"Return the block that will deal with the server side WebSocket,
	once a new WebSocket connection is accepted.
	The block will be evaluated with an instanciated ZnWebSocket instance as argument."

	^ handler! !

!ZnWebSocketDelegate methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
prefix
	"Return my prefix, the path elements under which I should handle a request"
	
	^ prefix! !


!ZnWebSocketDelegate methodsFor: 'initialize-release' stamp: '8/31/2024 11:18:34'!
handler: block
	"Set the block that will deal with the server side WebSocket"
	
	handler := block! !

!ZnWebSocketDelegate methodsFor: 'initialize-release' stamp: '8/31/2024 11:18:34'!
prefixFromString: string
	"Set the path prefix under which I should be handling request to string,
	interpreting each /-separated token as a path element"

	self prefix: (string findTokens: '/')! !


!ZnWebSocketDelegate methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
prefix: orderedCollection
	"Set my prefix to orderedCollection, interpreted as path elements.
	I will only handle requests that match."
	
	orderedCollection isEmpty
		ifFalse: [ prefix := orderedCollection ]! !

!ZnWebSocketDelegate methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
responseHeadersForKey: key
	"Return the headers for a WebSocket setup response, given key"
	
	^ ZnHeaders defaultResponseHeaders
			at: 'Upgrade' put: 'websocket';
			at: 'Connection' put: 'Upgrade';
			at: 'Sec-WebSocket-Accept' put: key;
			yourself! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZnWebSocketDelegate class
	instanceVariableNames: ''!
!ZnWebSocketDelegate class commentStamp: '<historical>' prior: 0!
I am ZnWebSocketDelegate, a plugin to allow a ZnServer to accept incoming WebSocket requests.

When accepted, the request is upgraded and a new WebSocket is created and handed to the handler block.

Here is how to get 3 examples up and running:

	ZnServer startDefaultOn: 1701.
	ZnServer default logToTranscript.
	ZnWebSocketDelegate installExamplesInDefaultServer.
	ZnServer stopDefault.

Part of Zinc HTTP Components.!


!ZnWebSocketDelegate class methodsFor: 'constants' stamp: '8/31/2024 11:18:34'!
demoHtml
	^ '<?xml version="1.0" encoding="UTF-8"?>
<!!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title>Zinc WebSocket Demo</title>
<style type="text/css">
body {
  color: black;
  background: white;
  width: 900px;
  font-family: Verdana, Arial, Helvetica, sans-serif;
  font-size: 13px;
}
p {
  width: 600px;
  padding: 0 20px 10px 20px;
} 
ul,ol {
  width: 600px;
  padding: 0 5px 5px 30px;
} 
#logo {
  color: orange;
  font-family: Helvetica, sans-serif;
  font-weight: bold;
  font-size: 100px;
}
li {
  margin-bottom: 1em;
}
</style>
</head>
<body>
<div id="logo">Zn</div>
<h1>Zinc WebSocket Demo</h1>
<ul>
  <li><a href="ws-echo-client">Echo</a> - websocket hello world: client connects, sends one message, server does an echo, client receives and shows message and disconnects</li>
  <li><a href="ws-echo-client-remote">Echo Remote</a> - websocket hello world against ws://echo.websocket.org (<a href="http://websocket.org">http://websocket.org</a>) for reference</li>
  <li><a href="ws-status-client">Status</a> - server side pushes continuous updates to client web page</li>
  <li><a href="ws-chatroom-client">Chatroom</a> - very simple chatroom: pick a handle and talk to all connected browsers</li>
</ul>
<h4>May the Source be with you!!</h4>
</body></html>'! !


!ZnWebSocketDelegate class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
handler: handler
	"Create and return a new ZnWebSocketDelegate that maps / to handler"

	^ self new
		handler: handler;
		yourself! !

!ZnWebSocketDelegate class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
map: prefix to: handler
	"Create and return a new ZnWebSocketDelegate that maps prefix string to handler"

	^ self new
		prefixFromString: prefix;
		handler: handler;
		yourself! !


!ZnWebSocketDelegate class methodsFor: 'examples' stamp: '8/31/2024 11:18:34'!
installExamplesInDefaultServer
	"Install the WebSocket examples in ZnServer default, 
	provided it has a ZnDefaultServerDelegate"
	
	self installExamplesInServer: ZnServer default! !

!ZnWebSocketDelegate class methodsFor: 'examples' stamp: '8/31/2024 11:18:34'!
installExamplesInServer: znServer
	"Install the WebSocket examples in znServer, provided it has a ZnDefaultServerDelegate"
	
	znServer delegate
	     map: 'ws-demo'
		to: [ :request | ZnResponse ok: (ZnEntity html: self demoHtml) ];
		map: 'ws-echo-client-remote' 
		to: [ :request | ZnResponse ok: (ZnEntity html: ZnWebSocketEchoHandler clientHtmlRemote) ];
		map: 'ws-echo-client' 
		to: [ :request | ZnResponse ok: (ZnEntity html: ZnWebSocketEchoHandler clientHtml) ];
		map: 'ws-echo'
		to: (self map: 'ws-echo' to: ZnWebSocketEchoHandler new);
		map: 'ws-chatroom-client' 
		to: [ :request | ZnResponse ok: (ZnEntity html: ZnWebSocketChatroomHandler clientHtml) ];
		map: 'ws-chatroom'
		to: (self map: 'ws-chatroom' to: ZnWebSocketChatroomHandler new);
		map: 'ws-status-client' 
		to: [ :request | ZnResponse ok: (ZnEntity html: ZnWebSocketStatusHandler clientHtml) ];
		map: 'ws-status'
		to: (self map: 'ws-status' to: ZnWebSocketStatusHandler new)! !


Object subclass: #ZnWebSocketFrame
	instanceVariableNames: 'opcode final masked body'
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketFrame commentStamp: '<historical>' prior: 0!
I am ZnWebSocketFrame, the elementary, low-level unit of data transfer in the WebSocket protocol.

A frame has an opcode (a type), a flag indicating whether it is the final frame in a sequence, a flag indicating whether it is masked and a body (a ByteArray).

The wire encoding of a frame consists minimally of 2 bytes: the first holds the opcode and final bit, the second the size and masked bit. Sizes strictly smaller than 126 are encoded directly. If the first byte is 126, the size is encoded in 2 successive bytes. If the first byte is 127, the size is encoded in 8 successive bytes. Client to server messages are masked. A 4 byte mask is XOR-ed with all body bytes. See #readFrom: and #writeOn: for the details.

This implementation follows RFC 6455. See also:

	http://en.wikipedia.org/wiki/Websockets
	http://tools.ietf.org/html/rfc6455

Part of Zinc HTTP Components.!


!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
body
	^ body! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
body: anObject
	body := anObject! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
closeCode
	self assert: self isClose.
	self assert: self isEmpty not.
	^ (body readStream next: 2) asInteger
	! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
closeReason
	self assert: self isClose.
	self assert: self isEmpty not.
	^ ZnUTF8Encoder new decodeBytes: (body allButFirst: 2)
	! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
contents
	self assert: self isControl not.
	^ self isText
		ifTrue: [ self text ]
		ifFalse: [ body ]! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
final
	^ final! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
final: anObject
	final := anObject! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
masked
	^ masked! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
masked: anObject
	masked := anObject! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
opcode
	^ opcode! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
opcode: anObject
	opcode := anObject! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
opcodeName
	| name |
	self assert: (opcode between: 0 and: 15).
	name := #(continuation text binary nil nil nil nil nil close ping pong nil nil nil nil nil) at: opcode + 1.
	^ name ifNil: [ opcode asString ] ifNotNil: [ name ]! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
size
	"Return the body size in bytes"
	
	^ body 
		ifNil: [ 0 ] 
		ifNotNil: [ body size ].! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
text
	^ ZnUTF8Encoder new decodeBytes: body! !

!ZnWebSocketFrame methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
text: string
	self body: (ZnUTF8Encoder new encodeString: string)
! !


!ZnWebSocketFrame methodsFor: 'initialize-release' stamp: '8/31/2024 11:18:34'!
initialize
	super initialize.
	final := true! !


!ZnWebSocketFrame methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isBinary
	^ opcode = 2! !

!ZnWebSocketFrame methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isClose
	^ opcode = 8! !

!ZnWebSocketFrame methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isContinuation
	^ opcode = 0! !

!ZnWebSocketFrame methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isControl
	^ opcode > 7! !

!ZnWebSocketFrame methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isEmpty
	^ self size = 0! !

!ZnWebSocketFrame methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isFinal
	^ final! !

!ZnWebSocketFrame methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isMasked
	^ masked! !

!ZnWebSocketFrame methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isPing
	^ opcode = 9! !

!ZnWebSocketFrame methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isPong
	^ opcode = 10! !

!ZnWebSocketFrame methodsFor: 'testing' stamp: '8/31/2024 11:18:34'!
isText
	^ opcode = 1! !


!ZnWebSocketFrame methodsFor: 'printing' stamp: '8/31/2024 11:18:34'!
printOn: stream
	super printOn: stream.
	stream 
		nextPut: $(; 
		print: self opcodeName;
		space;
		print: self size; nextPut: $B; 
		space;
		nextPutAll: (final ifTrue: [ 'final' ] ifFalse: [ 'non-final' ]);
		nextPut: $)! !


!ZnWebSocketFrame methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
readBodyOfSize: size from: stream
	| mask |
	masked 
		ifTrue: [ 
			mask := stream next: 4.
			body := ByteArray new: size streamContents: [ :out |
				1 to: size do: [ :index |
					out nextPut: (stream next bitXor: (mask at: ((index - 1) \\ 4) + 1)) ] ] ]
		ifFalse: [
			body := stream next: size ]! !

!ZnWebSocketFrame methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
writeBodyOfSize: size on: stream
	| mask |
	masked
		ifTrue: [
			mask := ZnWebSocketUtils newMask.
			stream nextPutAll: mask ].
	size = 0 ifTrue: [ ^ self ].
	masked 
		ifTrue: [
			body doWithIndex: [ :each :index |
				stream nextPut: (each bitXor: (mask at: ((index - 1) \\ 4) + 1)) ] ] 
		ifFalse: [ self writeRawBodyOn: stream ]! !

!ZnWebSocketFrame methodsFor: 'private' stamp: '8/31/2024 11:18:34'!
writeRawBodyOn: stream
	self isEmpty
		ifFalse: [ stream nextPutAll: body ]! !


!ZnWebSocketFrame methodsFor: 'reading' stamp: '8/31/2024 11:18:34'!
readFrom: stream
	| byte size mask |
	(byte := stream next) ifNil: [ ConnectionClosed signal ].
	final := (byte bitAt: 8) = 1.
	opcode := byte bitAnd: 127.
	(byte := stream next) ifNil: [ ConnectionClosed signal ].
	masked := (byte bitAt: 8) = 1.
	size := byte bitAnd: 127.
	size < 126
		ifFalse: [
			size = 126
				ifTrue: [ size := (stream next: 2) asInteger ]
				ifFalse: [ size := (stream next: 8) asInteger ].
			size = 0 ifTrue: [ ConnectionClosed signal ] ].
	self readBodyOfSize: size from: stream! !


!ZnWebSocketFrame methodsFor: 'writing' stamp: '8/31/2024 11:18:34'!
writeOn: stream
	| byte size |
	byte := (final ifTrue: [ 128 ] ifFalse: [ 0 ]) + opcode.
	stream nextPut: byte.
	byte := (masked ifTrue: [ 128 ] ifFalse: [ 0 ]).
	(size := self size) < 126
		ifTrue: [ stream nextPut: (byte + size) ]
		ifFalse: [
			size < 65536
				ifTrue: [ stream nextPut: (byte + 126); nextPutAll: (size asByteArrayOfSize: 2) ]
				ifFalse: [
					self assert: size < (2 raisedTo: 31).
					stream nextPut: (byte + 127); nextPutAll: (size asByteArrayOfSize: 8) ] ].
	self writeBodyOfSize: size on: stream ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

ZnWebSocketFrame class
	instanceVariableNames: ''!
!ZnWebSocketFrame class commentStamp: '<historical>' prior: 0!
I am ZnWebSocketFrame, the elementary, low-level unit of data transfer in the WebSocket protocol.

A frame has an opcode (a type), a flag indicating whether it is the final frame in a sequence, a flag indicating whether it is masked and a body (a ByteArray).

The wire encoding of a frame consists minimally of 2 bytes: the first holds the opcode and final bit, the second the size and masked bit. Sizes strictly smaller than 126 are encoded directly. If the first byte is 126, the size is encoded in 2 successive bytes. If the first byte is 127, the size is encoded in 8 successive bytes. Client to server messages are masked. A 4 byte mask is XOR-ed with all body bytes. See #readFrom: and #writeOn: for the details.

This implementation follows RFC 6455. See also:

	http://en.wikipedia.org/wiki/Websockets
	http://tools.ietf.org/html/rfc6455

Part of Zinc HTTP Components.!


!ZnWebSocketFrame class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
bytes: byteArray
	^ self new
		opcode: 2;
		final: true;
		body: byteArray;
		yourself! !

!ZnWebSocketFrame class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
close
	^ self new
		opcode: 8;
		final: true;
		yourself! !

!ZnWebSocketFrame class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
ping: bytes
	^ self new
		opcode: 9;
		final: true;
		body: bytes;
		yourself! !

!ZnWebSocketFrame class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
pong: bytes
	^ self new
		opcode: 10;
		final: true;
		body: bytes;
		yourself! !

!ZnWebSocketFrame class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
readFrom: stream
	^ self new
		readFrom: stream;
		yourself! !

!ZnWebSocketFrame class methodsFor: 'instance creation' stamp: '8/31/2024 11:18:34'!
text: string
	^ self new
		opcode: 1;
		final: true;
		text: string;
		yourself! !


ZnLogEvent subclass: #ZnWebSocketLogEvent
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketLogEvent commentStamp: 'SvenVanCaekenberghe 8/2/2014 18:53' prior: 0!
I am ZnWebSocketLogEvent, a ZnLogEvent.

I am the abstract superclass of all log events generated by the WebSocket subsystem.
!


ZnWebSocketLogEvent subclass: #ZnWebSocketControlFrameHandledEvent
	instanceVariableNames: 'type'
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketControlFrameHandledEvent commentStamp: 'SvenVanCaekenberghe 6/16/2014 13:10' prior: 0!
I am ZnWebSocketControlFrameHandledEvent.
I am a ZnLogEvent.

I am emitted when a WebSocket control frame is handled automatically. I know the type of frame that is being handled.!


!ZnWebSocketControlFrameHandledEvent methodsFor: 'printing' stamp: '8/31/2024 11:18:34'!
printContentsOn: stream
	super printContentsOn: stream.

	stream << 'WebSocket Control Frame Handled '; print: type! !


!ZnWebSocketControlFrameHandledEvent methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
type
	^ type! !

!ZnWebSocketControlFrameHandledEvent methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
type: anObject
	type := anObject! !


ZnWebSocketLogEvent subclass: #ZnWebSocketGenericLogEvent
	instanceVariableNames: 'subject'
	classVariableNames: ''
	package: 'Zinc-WebSocket-Core'!
!ZnWebSocketGenericLogEvent commentStamp: 'SvenVanCaekenberghe 6/16/2014 13:24' prior: 0!
I am ZnWebSocketGenericLogEvent communicating about a subject.
!


!ZnWebSocketGenericLogEvent methodsFor: 'printing' stamp: '8/31/2024 11:18:34'!
printContentsOn: stream
	super printContentsOn: stream.

	stream << 'WebSocket Generic Log Event ';  print: subject! !


!ZnWebSocketGenericLogEvent methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
subject
	^ subject! !

!ZnWebSocketGenericLogEvent methodsFor: 'accessing' stamp: '8/31/2024 11:18:34'!
subject: anObject
	subject := anObject! !
