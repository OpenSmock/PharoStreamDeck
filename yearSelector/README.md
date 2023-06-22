# PharoStreamDeck
This project shows how a plugin for the Elgato Stream Deck can interact with it. \
As such, a Stream Deck profile is provided alongside the plugin in order to see its functionality in action.

## How it functions
A user can tap one of the Stream Deck keys contained in the aforementioned Stream Deck profile, or place on one of the Stream Deck keys one of the actions of this plugin, titled **YearSelector**, **PercentSelector**, **YearWitness** and **PercentWitness**, available from the action list. On the Stream Deck, the pressed key will change color and appear blue, while the previous highlighted key will revert back to its original color. \
A JavaScript version exists as well as a Pharo version, each one having the same objective (the JavaScript version does not include the PercentSelector and PercentWitness actions). \
The profile keeps track of the values, for Selector actions as well as Witness ones.

## Pharo version
This version shows how Pharo, JavaScript and the Stream Deck SDK as well as JSON data sent through WebSockets can interact.

The Pharo profile is organized in the same way that the JavaScipt version is. \
It also functions the same way, having a YearSelector action and a YearWitness action.

In terms of structure, the MyYearSelector folder is a Pharo package which comports a YearSelector class, being the Pharo code, and a YearSelectorTest class.
The YearSelectorPharo JavaScript part folder is a mix between [basic WebSocket communication](https://github.com/OpenSmock/PharoStreamDeck/tree/main/webSocket) and [YearSelectorJS](https://github.com/OpenSmock/PharoStreamDeck/tree/main/yearSelector/YearSelectorJS).

How this plugin works and communicate with the differents parts involved is explained in this image :

![english pharo and stream deck drawio](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/63625b18-d2ca-43a2-9cd3-da3e5d60a313)

### MyApp package
The MyApp package is a way to interact with the YearSelector package (the aggregation link being here since it's possible to only launch a YearSelector instance without launching a MyApp instance, detailed further below in the UML diagram):

An instance of MyApp needs to be created in Pharo to launch a server and the second WebSocket.
In a Playground, execute the following line of code : `m := MyApp new`

Here's what it looks like after executing this Pharo line of code and launching the Stream Deck application, same as before: \
<img width="368" alt="myapp new1" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/c639c200-bec8-40a3-af51-690ef730dd31"> \
<img width="575" alt="pharostreamdeck not clicked" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/5efd1ce7-f18c-44ec-8319-ef7e4501fc8b">

Year actions are on the first row, Percent actions on the second. \
Left side of the profile : YearWitness and PercentWitness actions (which does not include the text accompanying them) \
Right side of the profile : YearSelector and PercentSelector actions

Then executing this second line of Pharo code: \
<img width="270" alt="myapp year10 2" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/6437d3f7-a4b0-46f7-bb54-5f77eb57799a"> \
<img width="573" alt="pharostreamdeck clicked" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/9de53d9f-78d2-4161-b3f9-2eba6eeefcf5">

The percent: method can also be used instead of the year: method to change the value shown on a PercentWitness instance, which can take the following values : 50, 100, 150 and 200.

### Pharo structure
![pharo structure drawio](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/b3ec9dfc-d1cc-4ea3-8ed5-0690a98d86b5)

## Complementary informations
### Pharo
[WebSocket (using Zinc)](https://github.com/svenvc/docs/blob/master/zinc/zinc-websockets-paper.md) \
[JSON support](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/ExternalProjects/Export/JSON.md) \
[MOOC](https://www.youtube.com/watch?v=JUKIjdjGjBU&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf)

### Elgato Stream Deck
[Stream Deck SDK](https://developer.elgato.com/documentation) \
[NumberDisplay plugin](https://developer.elgato.com/documentation/stream-deck/samples/numberdisplay)
