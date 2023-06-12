# How to install
Prerequisite :
- the Elgato Stream Deck application is installed on your device

Download the plugin and the profile, then double-click on them both. \
The profile will be available from the profile list without overriding other Stream Deck profiles, titled "YearSelectorPharo". \
The profile will have no effect without the plugin, since the actions cannot have any effect.

# How to use it
The YearSelector action permits the user to set a value to be taken by the plugin when clicked (5, 10, 15 or 20). \
When a key is pressed, its background color will be set to blue, and the last key pressed will revert to its original state (which is to say that its background will lose its blue status).

The YearWitness action shows which value is currently taken by the plugin global variable. \
Every YearWitness has the same value, since it's a global variable available to every instance of the plugin, which is different from how a YearSelector instance handles its internal value, being chosen from the Property Inspector list. \
Pressing a YearWitness value will put the value back to 0 and will also make its background blue.

## MyApp package
The MyApp package is a way to interact with the YearSelector package (the aggregation link being here since it's possible to launch a YearSelector instance without launching a MyApp instance, detailed further below in the UML diagram):

![MyApp and YearSelector drawio](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/f56fdeb7-6fc6-4f95-8185-636ef497063f)

Here's what it looks like after executing this Pharo line of code and launching the Stream Deck application, same as before: \
<img width="368" alt="myapp new1" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/c639c200-bec8-40a3-af51-690ef730dd31"> \
<img width="572" alt="defaultProfile" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/6e119585-7956-4961-9231-6e65538ae11b">

Then executing this second line of Pharo code: \
<img width="270" alt="myapp year10 2" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/6437d3f7-a4b0-46f7-bb54-5f77eb57799a"> \
<img width="571" alt="myapp year 10" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/121a09f6-d583-4f72-8bf7-3d3136ae98f9">

Of course, clicking on the Stream Deck keys still only highlights the key pressed, an operation which can't highlight multiple keys at the same time.
