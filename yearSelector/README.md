# YearSelector
This project shows how a plugin for the Elgato Stream Deck can interact with it. \
As such, a Stream Deck profile is provided alongside the plugin in order to see its functionality in action.

![js1](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/80b0d12e-17f7-4779-838d-68a0e61de41d) \

Left : YearWitness actions (not the text accompanying it) \
Right : YearSelector actions

![js2](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/b84a5d97-8a30-4773-95bc-4a609efff82c)

## How it functions
A user can tap one of the Stream Deck keys contained in the aforementioned Stream Deck profile, or place on one of the Stream Deck keys one of the actions of this plugin, titled **YearSelector** and **YearWitness**, available from the action list. On the Stream Deck, the pressed key will change color and appear blue, while the previous highlighted key will revert back to its original color. \
A JavaScript version exists as well as a Pharo version, each one having the same objective. \
When the application is launched (e.g. a Stream Deck task isn't present in the Task Manager), the values will be reset (a YearWitness won't keep track of its value, but a YearWitness keeps track of the value selected in its Property Inspector).

## Pharo version
This version shows how Pharo, JavaScript and the Stream Deck SDK as well as JSON data sent through WebSockets can interact.

The Pharo profile is organized in the same way that the JavaScipt version is. \
It also functions the same way, having a YearSelector action and a YearWitness action.

In terms of structure, the MyYearSelector folder is a Pharo package which comports a YearSelector class, being the Pharo code, and a YearSelectorTest class.
The YearSelectorPharo JavaScript part folder is a mix between [basic WebSocket communication](https://github.com/OpenSmock/PharoStreamDeck/tree/main/webSocket) and [YearSelectorJS](https://github.com/OpenSmock/PharoStreamDeck/tree/main/yearSelector/YearSelectorJS).

For now, an instance of a YearSelector needs to be created in Pharo to launch a server and the first WebSocket.
In a Playground, execute the following line of code : `YearSelector new`

How this plugin works and communicate with the differents parts involved is explained in this image : \

![english pharo and stream deck drawio](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/8c82ab61-47c6-4566-b1a1-7181ac434522)

## Complementary informations
### Pharo
[WebSocket (using Zinc)](https://github.com/svenvc/docs/blob/master/zinc/zinc-websockets-paper.md) \
[JSON support](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/ExternalProjects/Export/JSON.md) \
[MOOC](https://www.youtube.com/watch?v=JUKIjdjGjBU&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf)

### Elgato Stream Deck
[Stream Deck SDK](https://developer.elgato.com/documentation)
