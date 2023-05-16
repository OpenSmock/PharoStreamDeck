# How to install
Prerequisite :
- the Elgato Stream Deck application is installed on your device

Download the plugin and the profile, then double-click on them both. \
The profile will be available from the profile list without overriding other Stream Deck profiles. \
The profile will have no effect without the plugin, since the actions cannot have any effect. \

# How to use it
The YearSelector action permits the user to set a value to be taken by the plugin when clicked (5, 10, 15 or 20). \
When a key is pressed, its background color will be set to blue, and the last key pressed will revert to its original state (which is to say that its background will lose its blue status). \

The YearWitness action shows which value is currently taken by the plugin variable. \
Every YearWitness has the same value, since it's a global variable, available to every instance of the plugin, which is different from how the YearSelector handle its internal values. \
Pressing a YearWitness value will put the value back to 0 and will also make its background blue.
