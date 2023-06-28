This project shows how a plugin for the Elgato Stream Deck can interact with it, with the memorization of a value between several instances of the plugin's actions being its major focus. \
As such, a Stream Deck profile is provided alongside the plugin in order to see its functionalities in action.

# JavaScript version (YearSelectorJS plugin)
## How it functions
A user can tap one of the Stream Deck keys contained in the aforementioned Stream Deck profile, or place on one of the Stream Deck keys one of the actions of the plugin, titled **YearSelector** and **YearWitness** which are available from the action list. \
When a Selector action is clicked, the pressed key will change color and appear blue, while the previous highlighted key will revert back to its original color. The Witness instances will also change their value. \
The profile keeps track of the values, for Selector actions as well as Witness ones, which mean that when the Stream Deck software is opened again the same values will be shown on the profile.

You can download this plugin from its [Release](https://github.com/OpenSmock/PharoStreamDeck/tree/main/yearSelector/YearSelectorJS/Release) folder.

# Pharo version (PharoStreamDeck plugin)
This version shows how Pharo, JavaScript and the Stream Deck SDK as well as JSON data sent through WebSockets can interact.

The Pharo profile is organized in the same way as the JavaScript version. \
It also functions the same way, having a YearSelector action and a YearWitness action where this version also includes the **PercentSelector** and **PercentWitness** actions.

The detailed documentation of this plugin is available in its [Release](https://github.com/OpenSmock/PharoStreamDeck/tree/main/yearSelector/YearSelectorPharo/YearSelectorPharo%20JavaScript%20part/Release) folder which is also where you can download it.

## Complementary informations
### Pharo
[WebSocket (using Zinc)](https://github.com/svenvc/docs/blob/master/zinc/zinc-websockets-paper.md) \
[JSON support](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/ExternalProjects/Export/JSON.md) \
[MOOC](https://www.youtube.com/watch?v=JUKIjdjGjBU&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf)

### Elgato Stream Deck
[Stream Deck SDK](https://developer.elgato.com/documentation) \
[NumberDisplay plugin](https://developer.elgato.com/documentation/stream-deck/samples/numberdisplay)
