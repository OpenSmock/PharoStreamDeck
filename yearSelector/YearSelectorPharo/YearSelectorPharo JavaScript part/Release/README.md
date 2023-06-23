# How to install
Prerequisite :
- the Elgato Stream Deck application is installed on your device

Download the plugin and the profile, then double-click on them both. \
The profile will be available from the profile list without overriding other Stream Deck profiles and is titled **PharoStreamDeck**. \
The profile will have no effect without the plugin, since the actions cannot have any effect by themselves.

In a Pharo VM, execute the following import command in a Playground:
```
Metacello new
               baseline: 'MyYearSelector';
               repository: 'github://OpenSmock/PharoStreamDeck:Dev/yearSelector/YearSelectorPharo';
               onConflictUseIncoming;
               load
```
Then, click on the **Browse** tab and select the **Git Repositories Browser** option. \
Click on the **zinc** package and scroll to the bottom until you attain **Zinc-WebSocket-Core**. Right-click on it and select **Load**.

# How to use it
The YearSelector action permits the user to set a value to be taken by the plugin when clicked (5, 10, 15 or 20). \
When a key is pressed, its background color will be set to blue, and the last key pressed will revert to its original state (which is to say that its background will lose its blue status).

The YearWitness action shows which value is currently taken by the plugin global variable. \
Every YearWitness has the same value, since it's a global variable available to every instance of the plugin, which is different from how a YearSelector instance handles its internal value, being chosen from the Property Inspector list. \
Pressing a YearWitness value will put the value back to 0 and will also make its background blue.

PercentSelector and PercentWitness work in the same way, where PercentSelector can take the following values : 50, 100, 150 and 200.

### AppLaunch package
The AppLaunch package is a way to interact with the YearSelector and PercentSelector classes.

An instance of AppLaunch needs to be created in Pharo to launch a server and the second WebSocket.
In a Playground, execute the following line of code : `a := AppLaunch new`

Here's what it looks like after executing this previous Pharo line of code and launching the Stream Deck application, same as before: \
<img width="575" alt="pharostreamdeck not clicked" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/5efd1ce7-f18c-44ec-8319-ef7e4501fc8b">

Year actions are on the first row, Percent actions on the second. \
Left side of the profile : YearWitness and PercentWitness actions (which does not include the text accompanying them) \
Right side of the profile : YearSelector and PercentSelector actions

The year value can be between 0, 5, 10, 15 and 20.
The percent value can be between 50, 100, 150 and 200.

Then executing these lines of Pharo code:
```
a year: 10.
a percent: 100
```
<img width="573" alt="pharostreamdeck clicked" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/9de53d9f-78d2-4161-b3f9-2eba6eeefcf5">

### GUI
<img width="1280" alt="gui" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/f55fe157-b297-4245-819a-9621e77d35ca">

Pressing on the graphical interface's buttons has the same effect as pressing a key of the PharoStreamDeck plugin on the Stream Deck. \
Sending a command through the Playground with the help of the AppLaunch class (such as using the year: or percent: methods) will highlight the pressed Selector instance and modify the correct Witness instance. \
Conversely, pressing one of the plugin keys on the Stream Deck will impact what is shown on the graphical interface.

## Complementary informations
### Pharo
[WebSocket (using Zinc)](https://github.com/svenvc/docs/blob/master/zinc/zinc-websockets-paper.md) \
[JSON support](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/ExternalProjects/Export/JSON.md) \
[MOOC](https://www.youtube.com/watch?v=JUKIjdjGjBU&list=PL2okA_2qDJ-kCHVcNXdO5wsUZJCY31zwf)

### Elgato Stream Deck
[Stream Deck SDK](https://developer.elgato.com/documentation) \
[NumberDisplay plugin](https://developer.elgato.com/documentation/stream-deck/samples/numberdisplay)
