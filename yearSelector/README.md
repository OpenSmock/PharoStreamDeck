# YearSelector
This project shows how a plugin for the Elgato Stream Deck can interact with it. \
As such, a Stream Deck profile is provided alongside the plugin in order to see its functionality in action.

![yearSelector profile](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/9e970b04-69df-46e2-a807-286cb1cfbf3e) \
Left : YearWitness actions (not the text accompanying it) \
Right : YearSelector actions

![clicked YearSelector profile](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/a4ecf106-4308-4840-930d-9d61baeea9ef)

## How it functions
A user can tap one of the Stream Deck keys contained in the aforementioned Stream Deck profile, or place on one of the Stream Deck keys one of the actions of this plugin, titled **YearSelector** and **YearWitness**, available from the action list. On the Stream Deck, the pressed key will change color and appear blue, while the previous highlighted key will revert back to its original color. \
A JavaScript version exists as well as a Pharo version, each one having the same objective. \
When the application is launched (e.g. a Stream Deck task isn't present in the Task Manager), the values will be reset (a YearWitness won't keep track of its value).

### Pharo version
![english pharo and stream deck drawio](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/6e3cd0dd-d41a-476e-aaf7-17bb6abf0adb)
![english stream deck diagram drawio](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/4c8689be-3953-449c-a826-cfabc424eed6)

## Complementary informations
### Pharo
[WebSocket (using Zinc)](https://github.com/svenvc/docs/blob/master/zinc/zinc-websockets-paper.md) \
[JSON support](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/ExternalProjects/Export/JSON.md) \
[MOOC](https://www.youtube.com/watch?v=JUKIjdjGjBU)

### Elgato Stream Deck
[Stream Deck SDK](https://developer.elgato.com/documentation)
