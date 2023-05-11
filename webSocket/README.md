# Basic WebSocket communication in Pharo
This project permits the communication between a Web page wrote in HTML and JavaScript and a server written in Pharo.
Its primary features are as described below:
- Automatic reconnection to the server until one is launched
- Secure connection by use of the secure WebSocket variant wss://
- Communication possible between the server and the Web page through JSON strings sent in a WebSocket (use of the following methods: JSON.stringify() and JSON.parse() for the JavaScript side, STONJSON toString: and STONJSON fromString: for the Pharo side)
- Web page checks if the WebSocket is open before sending a message through the isOpen() method

## Testing this project
Launch server.html, execute the code contained within server.st in a Playground, then you should see some data sent from Pharo being shown in the Developer Tools of your Web browser (opened via F12), and the URL of server.html (starting with file://, the location of your file in your file explorer) being sent to Pharo.

## Complementary informations
### Pharo
[WebSocket (using Zinc)](https://github.com/svenvc/docs/blob/master/zinc/zinc-websockets-paper.md) \
[JSON support](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/ExternalProjects/Export/JSON.md) \
[MOOC](https://www.youtube.com/watch?v=JUKIjdjGjBU)

### Elgato Stream Deck
[Stream Deck SDK](https://developer.elgato.com/documentation)
