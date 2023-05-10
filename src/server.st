| server client |
server := ZnWebSocket startServerOn: 8888 prefix: 'pharoEndpoint' do: [ :webSocket |
        [ webSocket runWith: [ :message | self inform: 'Received message: ', message
printString ] ]
        on: ConnectionClosed, PrimitiveFailed do: [ "ignore close" ].
         self inform: 'The server is closed' ].