| json jsonObject |
"is used to send JSON data to JavaScript, which logs the contents of its fields in the Developer Tools (F12 in a Web browser)"
jsonObject := Dictionary new
	at: 'event' put: 'inRegisterEvent';
	at: 'uuid' put: 'inPluginUUID';
	yourself.
json := STONJSON toString: jsonObject.

"Creates a ZnManagingMultiThreadedServer HTTP port 8888, which needs to be terminated through the Process Browser if another server is to be launched"
server := ZnWebSocket startServerOn: 8080 prefix: 'pharoEndpoint' do: 
	[ :webSocket |
      [ webSocket runWith: 
			[ :message | self inform: 'Received message: ', message
printString.
			webSocket sendMessage: json.
			]
		]
      on: ConnectionClosed, PrimitiveFailed do: [ "ignore close" ].
      self inform: 'The server is closed' 
	].
