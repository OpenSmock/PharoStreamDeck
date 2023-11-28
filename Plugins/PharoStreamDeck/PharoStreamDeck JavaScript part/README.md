# The JavaScript side of things
In terms of structure, the [Sources](https://github.com/OpenSmock/PharoStreamDeck/tree/main/Plugins/PharoStreamDeck/PharoStreamDeck%20JavaScript%20part/Sources/com.thales.pharostreamdeck.sdPlugin) subfolder is a mix between [basic WebSocket communication](https://github.com/OpenSmock/PharoStreamDeck/tree/main/webSocket) and [YearSelectorJS](https://github.com/OpenSmock/PharoStreamDeck/tree/main/Plugins/YearSelectorJS).

How this plugin works and communicates with the differents parts involved is explained in this image (notably uses a second WebSocket):
![english pharo and stream deck drawio](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/e57389f7-9eb3-42a5-a642-e1fbeefea8e6)

## Complementary informations
### Pharo
[WebSocket (using Zinc)](https://github.com/svenvc/docs/blob/master/zinc/zinc-websockets-paper.md) \
[JSON support](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/ExternalProjects/Export/JSON.md) \
[MOOC](https://www.youtube.com/watch?v=JUKIjdjGjBU&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf)

### Elgato Stream Deck
[Stream Deck SDK](https://developer.elgato.com/documentation) \
[NumberDisplay plugin](https://developer.elgato.com/documentation/stream-deck/samples/numberdisplay)
