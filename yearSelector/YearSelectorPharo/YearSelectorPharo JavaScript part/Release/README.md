# How to install
Prerequisite :
- the Elgato Stream Deck application is installed on your device (which you can download from [here](https://www.elgato.com/us/en/s/downloads), by selecting the Stream Deck category)

Download the plugin and the profile, then double-click on them both. They're both named **PharoStreamDeck**. \
The profile will be available from the profile list without overriding other Stream Deck profiles. It will have no effect without the plugin since the actions cannot have any effect by themselves.

In a Pharo VM, execute the following import command in a Playground:
```smalltalk
Metacello new
               baseline: 'MyYearSelector';
               repository: 'github://OpenSmock/PharoStreamDeck:Dev/yearSelector/YearSelectorPharo';
               onConflictUseIncoming;
               load
```
Then, click on the **Browse** tab and select the **Git Repositories Browser** option. \
Click on the **zinc** package and scroll to the bottom until you attain **Zinc-WebSocket-Core**. Right-click on it and select **Load**.

# How to use it
The YearSelectorPhaeo action permits the user to set a value to be taken by the plugin when clicked (0, 5, 10, 15 or 20). \
When a key is pressed, its background color will be set to blue, and the last key pressed will revert to its original state (which is to say that its background will lose its blue status). \
<img width="107" alt="yearselectorpharo action list" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/c4851239-fcb6-40ca-90ff-7f94916f9f95">

The YearWitnessPharo action shows which value is currently taken by the plugin global variable. \
Every YearWitness has the same value, since it's a global variable available to every instance of the plugin, which is different from how a YearSelector instance handles its internal value, being chosen from the Property Inspector list. \
Pressing a YearWitness value will put the value back to 0 and will also make its background blue. \
<img width="120" alt="yearwitness actionlist" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/97dfb236-9805-40ef-9c63-18848b7e7243">

PercentSelector and PercentWitness work in the same way where PercentSelector can take the following values : 50, 100, 120 and 200.
<img width="104" alt="percentselector action list" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/5fa62531-4ea3-41bc-9634-e3d9d365b965">
<img width="107" alt="percentwitness action list" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/34efcc55-7a53-448c-95d5-c3c2c7bef0ef">

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
The percent value can be chosen between 50, 100, 150 and 200.

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
