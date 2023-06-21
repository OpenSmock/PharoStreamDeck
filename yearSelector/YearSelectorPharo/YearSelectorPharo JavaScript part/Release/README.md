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

## MyApp package
The MyApp package is a way to interact with the YearSelector package (the aggregation link being here since it's possible to only launch a YearSelector instance without launching a MyApp instance, detailed further below in the UML diagram):

An instance of MyApp needs to be created in Pharo to launch a server and the second WebSocket.
In a Playground, execute the following line of code : `m := MyApp new`

Here's what it looks like after executing this Pharo line of code and launching the Stream Deck application, same as before: \
<img width="368" alt="myapp new1" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/c639c200-bec8-40a3-af51-690ef730dd31"> \
<img width="572" alt="defaultProfile" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/6e119585-7956-4961-9231-6e65538ae11b">

Then executing this second line of Pharo code: \
<img width="270" alt="myapp year10 2" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/6437d3f7-a4b0-46f7-bb54-5f77eb57799a"> \
<img width="571" alt="myapp year 10" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/121a09f6-d583-4f72-8bf7-3d3136ae98f9">

The percent: method can also be used instead of the year: method to change the value of the launched PercentSelector instance.

# How to use it
The YearSelector action permits the user to set a value to be taken by the plugin when clicked (5, 10, 15 or 20). \
When a key is pressed, its background color will be set to blue, and the last key pressed will revert to its original state (which is to say that its background will lose its blue status).

The YearWitness action shows which value is currently taken by the plugin global variable. \
Every YearWitness has the same value, since it's a global variable available to every instance of the plugin, which is different from how a YearSelector instance handles its internal value, being chosen from the Property Inspector list. \
Pressing a YearWitness value will put the value back to 0 and will also make its background blue.

PercentSelector and PercentWitness work in the same way, where PercentSelector can take the following values : 50, 100, 150 and 200.
