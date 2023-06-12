# YearSelector
This project shows how a plugin for the Elgato Stream Deck can interact with it. \
As such, a Stream Deck profile is provided alongside the plugin in order to see its functionality in action.

![templateYS](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/be07240b-ace2-4aa6-ba96-465fe82a884d)

Left : YearWitness actions (not the text accompanying it) \
Right : YearSelector actions

![templateYS2](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/1a4657df-7691-4ae3-a7d6-ed432287ab53)

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

How this plugin works and communicate with the differents parts involved is explained in this image :

![english pharo and stream deck drawio](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/6f4ce01d-0e77-4a1a-b5ad-8457bf6763aa)

## MyApp package
The MyApp package is a way to interact with the YearSelector package (the aggregation link being here since it's possible to only launch a YearSelector instance without launching a MyApp instance, detailed further below in the UML diagram):

![MyApp and YearSelector drawio](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/f56fdeb7-6fc6-4f95-8185-636ef497063f)

Here's what it looks like after executing this Pharo line of code and launching the Stream Deck application, same as before: \
<img width="368" alt="myapp new1" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/c639c200-bec8-40a3-af51-690ef730dd31"> \
<img width="572" alt="defaultProfile" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/6e119585-7956-4961-9231-6e65538ae11b">

Then executing this second line of Pharo code: \
<img width="270" alt="myapp year10 2" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/6437d3f7-a4b0-46f7-bb54-5f77eb57799a"> \
<img width="571" alt="myapp year 10" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/121a09f6-d583-4f72-8bf7-3d3136ae98f9">

## Complementary informations
### Pharo
[WebSocket (using Zinc)](https://github.com/svenvc/docs/blob/master/zinc/zinc-websockets-paper.md) \
[JSON support](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/ExternalProjects/Export/JSON.md) \
[MOOC](https://www.youtube.com/watch?v=JUKIjdjGjBU&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf)

### Elgato Stream Deck
[Stream Deck SDK](https://developer.elgato.com/documentation) \
[NumberDisplay plugin](https://developer.elgato.com/documentation/stream-deck/samples/numberdisplay)
