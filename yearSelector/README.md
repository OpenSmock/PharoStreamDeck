# YearSelectorJS
This project shows how a plugin for the Elgato Stream Deck can interact with it, with the memorization of a value between several instances of the plugin's actions being its major focus. \
As such, a Stream Deck profile is provided alongside the plugin in order to see its functionality in action.

## How it functions
A user can tap one of the Stream Deck keys contained in the aforementioned Stream Deck profile, or place on one of the Stream Deck keys one of the actions of the plugin, titled **YearSelector** and **YearWitness** which are available from the action list. \
When a Selector action is clicked, the pressed key will change color and appear blue, while the previous highlighted key will revert back to its original color. The relevant Witness instance will also change its value. \
The profile keeps track of the values, for Selector actions as well as Witness ones, which mean that when the Stream Deck software is opened again the same values will be shown on the profile.

# Pharo version (PharoStreamDeck plugin)
This version shows how Pharo, JavaScript and the Stream Deck SDK as well as JSON data sent through WebSockets can interact.

The Pharo profile is organized in the same way as the JavaScript version. \
It also functions the same way, having a YearSelector action and a YearWitness action. \
The Pharo version also includes the **PercentSelector** and **PercentWitness** actions.

In terms of structure, the YearSelectorPharo JavaScript part folder is a mix between [basic WebSocket communication](https://github.com/OpenSmock/PharoStreamDeck/tree/main/webSocket) and [YearSelectorJS](https://github.com/OpenSmock/PharoStreamDeck/tree/main/yearSelector/YearSelectorJS).

How this plugin works and communicate with the differents parts involved is explained in this image :
![english pharo and stream deck drawio](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/0cff7dfb-4a01-4a50-8b02-3ae1a9db9d9a)

### AppLaunch package
The AppLaunch package is a way to interact with the YearSelector and PercentSelector classes.

An instance of AppLaunch needs to be created in Pharo to launch a server and the second WebSocket.
In a Playground, execute the following line of code : `a := AppLaunch new`

Here's what it looks like after executing this previous Pharo line of code and launching the Stream Deck application, same as before: \
<img width="572" alt="stream deck not clicked" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/fe134aae-a2b2-4a8f-a405-668ed34ec81b">

Year actions are on the first row, Percent actions on the second. \
Left side of the profile : YearWitness and PercentWitness actions (text not being part of the plugin) \
Right side of the profile : YearSelector and PercentSelector actions

The year value can be chosen between 0, 5, 10, 15 and 20. \
The percent value can be chosen between 50, 100, 120 and 200.

Then executing these lines of Pharo code:
```smalltalk
a year: 10.
a percent: 100
```
<img width="575" alt="100 10 clicked" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/71e90616-8a84-473c-8709-3c94013816b9">

### GUI
<img width="1280" alt="updated gui" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/b16c2019-22b3-47c4-8558-4e1e461dabd7">
Pressing one of the plugin keys on the Stream Deck, as well as pressing one of the graphical interface's buttons or using the year: and percent: methods in conjunction with the AppLaunch class, will highlight the pressed Selector instance on the Stream Deck as well as on the graphical interface, but also update the relevant Witness instance (relevant in terms of which plugin is selected).

After executing the previous lines of Pharo code:
<img width="1280" alt="100 10 clicked gui" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/d608622e-04d2-4d62-8cbb-633bba5021df">

One of the other uses of this GUI is that it can interact with the Stream Deck application (with the plugin and its profile) even if a Stream Deck is not plugged in.

## Complementary informations
### Pharo
[WebSocket (using Zinc)](https://github.com/svenvc/docs/blob/master/zinc/zinc-websockets-paper.md) \
[JSON support](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/ExternalProjects/Export/JSON.md) \
[MOOC](https://www.youtube.com/watch?v=JUKIjdjGjBU&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf)

### Elgato Stream Deck
[Stream Deck SDK](https://developer.elgato.com/documentation) \
[NumberDisplay plugin](https://developer.elgato.com/documentation/stream-deck/samples/numberdisplay)
