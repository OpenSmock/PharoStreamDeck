# How to install
Prerequisite:
- the Elgato Stream Deck application is installed on your device

Download the plugin and the profile, then double-click on them both. \
The profile will be available from the profile list without overriding other Stream Deck profiles, titled **YearSelectorJS**. \
<img width="117" alt="pluginjs" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/227e0cc7-fafe-4f41-883b-b519e6559e3c">
The profile will have no effect without the plugin since the actions cannot have any effect by themselves. \

# How to use the plugin
The YearSelectorJS action permits the user to set a value to be taken by the plugin when clicked (5, 10, 15 or 20). \
<img width="92" alt="yearselectorjs" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/34b1aa18-3053-4460-8d3d-dce62e33a12e">
When a key is pressed, its background color will be set to blue, and the last key pressed will revert to its original state (which is to say that its background will lose its blue status). \

The YearWitnessJS action shows which value is currently taken by the plugin global variable. \
<img width="83" alt="yearwitnessjs" src="https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/3900b566-f0fd-4ba7-b87b-80811f0be291">
Every YearWitnessJS has the same value, since it's a global variable available to every instance of the plugin, which is different from how a YearSelectorJS instance handles its internal value, being chosen from the Property Inspector list. \
Pressing a YearWitnessJS value will put the value back to 0 and will also make its background blue. \
