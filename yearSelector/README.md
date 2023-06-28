# JavaScript version (YearSelectorJS plugin)
This project shows how a plugin for the Elgato Stream Deck can interact with it, with the memorization of a value between several instances of the plugin's actions being its major focus. \
As such, a Stream Deck profile is provided alongside the plugin in order to see its functionality in action.

## How it functions
A user can tap one of the Stream Deck keys contained in the aforementioned Stream Deck profile, or place on one of the Stream Deck keys one of the actions of the plugin, titled **YearSelector** and **YearWitness** which are available from the action list. \
When a Selector action is clicked, the pressed key will change color and appear blue, while the previous highlighted key will revert back to its original color. The Witness instances will also change their value. \
The profile keeps track of the values, for Selector actions as well as Witness ones, which mean that when the Stream Deck software is opened again the same values will be shown on the profile.

# Pharo version (PharoStreamDeck plugin)
This version shows how Pharo, JavaScript and the Stream Deck SDK as well as JSON data sent through WebSockets can interact.

The Pharo profile is organized in the same way as the JavaScript version. \
It also functions the same way, having a YearSelector action and a YearWitness action. \
The Pharo version also includes the **PercentSelector** and **PercentWitness** actions.

In terms of structure, the [Sources](https://github.com/OpenSmock/PharoStreamDeck/tree/main/yearSelector/YearSelectorPharo/YearSelectorPharo%20JavaScript%20part/Sources/com.thales.pharostreamdeck.sdPlugin) subfolder of the [YearSelectorPharo JavaScript part folder](https://github.com/OpenSmock/PharoStreamDeck/tree/main/yearSelector/YearSelectorPharo/YearSelectorPharo%20JavaScript%20part) is a mix between [basic WebSocket communication](https://github.com/OpenSmock/PharoStreamDeck/tree/main/webSocket) and [YearSelectorJS](https://github.com/OpenSmock/PharoStreamDeck/tree/main/yearSelector/YearSelectorJS).

How this plugin works and communicates with the differents parts involved is explained in this image :
![english pharo and stream deck drawio](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/e57389f7-9eb3-42a5-a642-e1fbeefea8e6)

## Complementary informations
### Pharo
[WebSocket (using Zinc)](https://github.com/svenvc/docs/blob/master/zinc/zinc-websockets-paper.md) \
[JSON support](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/ExternalProjects/Export/JSON.md) \
[MOOC](https://www.youtube.com/watch?v=JUKIjdjGjBU&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf)

### Elgato Stream Deck
[Stream Deck SDK](https://developer.elgato.com/documentation) \
[NumberDisplay plugin](https://developer.elgato.com/documentation/stream-deck/samples/numberdisplay)
