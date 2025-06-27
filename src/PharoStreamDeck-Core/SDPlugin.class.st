"
**For the Class part:** I am used to launch the server, to receive and send events to the Stream Deck.

**For the Responsibility part:** I launch a server then treat the different events that are received from _index.html_ (the JavaScript side of the plugin, which also sends some info about the Stream Deck at its launch). With the use of the `SDPlugin>>#initServer` method, each event is treated by the relevant Pharo class.

**For the Collaborators Part:** My main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin.

**How to create instances:**
_SDPlugin new._

**Instance variables:**
- webSocket : a `ZnWebSocket` launched in `SDPlugin>>#initServer` to send messages between _index.html_ and `SDSharedActions` tool instances contained in arrayTools
- serverStarted : a value that indicates if the server is launched or not

**Shared variables:**
- arrayTools : an `OrderedCollection` of tools (`SDSharedActions`)
"
Class {
	#name : 'SDPlugin',
	#superclass : 'Object',
	#instVars : [
		'serverStarted',
		'webSocket'
	],
	#classVars : [
		'arrayTools'
	],
	#category : 'PharoStreamDeck-Core',
	#package : 'PharoStreamDeck-Core'
}

{ #category : 'accessing' }
SDPlugin >> arrayTools [
	"Returns the list of tools"

	^ arrayTools
]

{ #category : 'connection' }
SDPlugin >> connected: aWebsocket receives: aMessage [
	"Manages the receipt of socket messages according to their event type"

	| jsonObject event |

	"Retrieves the received information"
	jsonObject := STONJSON fromString: aMessage.
	event := jsonObject at: 'event'.

	"A connexion is started"
	event = 'registerPlugin' ifTrue: [ self registerPluginEvent: jsonObject ].
	
	"An action appears on the Stream Deck"
	event = 'willAppear' ifTrue: [ self willAppearEvent: jsonObject ].

	"An action key is pressed"
	event = 'keyUp' ifTrue: [ self keyUpEvent: jsonObject ].

]

{ #category : 'initialization' }
SDPlugin >> initServer [
	"Creates a ZnWebSocket HTTP port 8080 process, which needs to be terminated through the Process Browser if another server must be launched"
	
	| server |
	
	"Creates a socket"
	server := ZnWebSocket
		startServerOn: 8080
		prefix: 'pharoBridge'
		do: [ :aWebSocket |
			
			"Socket connected"
			[ aWebSocket isConnected
				ifTrue: [
					self serverStarted: true.
					self webSocket: aWebSocket .
					aWebSocket runWith: [ :message |
						self inform: 'Received message: ' , message printString.
						self connected: aWebSocket receives: message ] ]
				ifFalse: [ self error: 'The socket isn''t connected' ] ]
			
			"Ignore close"
			on: ConnectionClosed , PrimitiveFailed
			do: [ self serverStarted: nil ].
			
			"Socket disconnected"
			self inform: 'The server is closed'.
			self serverStarted: nil.
			SDAppLaunch cleanUp ].
]

{ #category : 'initialization' }
SDPlugin >> initialize [
	"Creates the instance and starts the server if it hasn't been started yet"

	super initialize.

	arrayTools := SDAppLaunch arrayTools.
	self serverStarted ifNil: [ self initServer ]
]

{ #category : 'event' }
SDPlugin >> keyUpEvent: jsonObj [
	"When a key is pressed, sends a message to the class corresponding."
	
	| actualPlugin |
	
	actualPlugin := self whichAction: (jsonObj at: 'action').
	
	^ actualPlugin 
]

{ #category : 'event' }
SDPlugin >> registerPluginEvent: aJSONObject [
	"When a connexion is started, answers to the sender in order to validate the connection"

	webSocket sendMessage: (STONJSON toString: aJSONObject)
]

{ #category : 'accessing' }
SDPlugin >> serverStarted [
	"Indicates if the server is started (true) or not (nil)"

	^ serverStarted
]

{ #category : 'accessing' }
SDPlugin >> serverStarted: aBoolean [
	"Allows to change the server's state: true or nil"

	serverStarted := aBoolean
]

{ #category : 'accessing' }
SDPlugin >> uuid [
	"Returns the plugin unique identifier"

	^ 'com.thales.pharostreamdeck'
]

{ #category : 'accessing' }
SDPlugin >> webSocket [
	"Returns the webSocket launched to send and receive messages to/from the server"

	^ webSocket
]

{ #category : 'accessing' }
SDPlugin >> webSocket: aWebSocket [
	"Sets the websocket to given parameter. The launched webSocket is used to send and receive messages to and from the server"

	webSocket := aWebSocket
]

{ #category : 'actions' }
SDPlugin >> whichAction: anAction [
	"Sends a message to the class corresponding to the socket message"

	"Finds the corresponding class and sends it a message to activate its action"
	arrayTools do: [ :aTool |
		(aTool uuidAction = anAction) ifTrue: [
			aTool pluginAction. 
			^ aTool ] ].
	
	"If no class is found"
	self error: 'There''s an issue with your plugin''s UUID'
]

{ #category : 'event' }
SDPlugin >> willAppearEvent: jsonObj [
	"When a action appears on the Stream Deck"

	"Does nothing in particular here, just informs us that it works"
	self inform: jsonObj
]

{ #category : 'event' }
SDPlugin >> willDisappearEvent: jsonObj [
	"When a action disappears from the Stream Deck"
	
	"To implement"

	^ self
]
