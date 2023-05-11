# Stream Deck Pharo Profile
Features buttons executing some essential Pharo keyboard shortcuts, which can be quite convoluted (all keyboard shortcuts mentioned in parenthesis are as shown on Windows on the Pharo IDE as of 10/05/2023):
Designed for a Stream Deck XL, with each horizontal line being dedicated a specific part of the Pharo IDE, containing 28 pushable buttons in total, two of them being repeated for the sake of convenience, and the first four buttons of each line being there to indicate what their respective line has in terms of functionalities.
The images provided all come from the standard icons library provided by Elgato by default.
System Browser actions are not supported at the moment.

![profile](https://github.com/OpenSmock/PharoStreamDeck/assets/76944457/e9d6a12b-8e3c-4446-999f-5c48ec1bf64e)

## System actions 
### as available in Pharo IDE tabs, being the first horizontal line of the Stream Deck profile

- Save (Ctrl+Shift+S)
- Iceberg (Ctrl+O+I)
- System Browser (Ctrl+O+B)
- Playground (Ctrl+O+W)
- Transcript (Ctrl+O+T)
- Test Runner (Ctrl+O+U)
- Spotter (Shift+Enter)

## Code actions 
### as available while right-clicking a Playground or Transcript, being the second horizontal line of the Stream Deck profile
- Do it (Ctrl+D)
- Back action (Ctrl+Z)
- Forward action (Ctrl+Shift+Z)
- Debug (Shift+Ctrl+D)
- Print (Ctrl+P)
- Inspect (Ctrl+I)
- Do it and Go (Ctrl+G)

## Process Browser specific actions 
### some actions are already present in previous horizontal lines of the Stream Deck profiles, such as Inspect and Debug, those two shortcuts being there a second time since they're useful
### as available while right-clicking a Process Browser, being the third and fourth horizontal lines of the Stream Deck profile
- Explore (Ctrl+Shift+I)
- Inspect Pointers (Ctrl+Shift+P)
- Terminate (Ctrl+T)
- Suspend (Ctrl+S)
- Change priority (Ctrl+P)
- Profile message (Ctrl+M)
- Signal Semaphore (Ctrl+Shift+S)
- Full stack (Ctrl+K)
- Find context (Ctrl+F)
- Find again (Ctrl+G)
- Turn on/off auto-update (Ctrl+A)
- Update list (Ctrl+U)

## Installation
Download the file, then double-click it. If the Stream Deck application is installed on your computer, the profile will be imported on it with the name "Pharo".

Note: some of the keyboard shortcuts used in this profile require the SuperMacro plugin (available [here](https://github.com/BarRaider/streamdeck-supermacro), or directly via the Stream Deck store). As a matter of fact, some Pharo keyboard shortcuts require simultaneous alphabetical keys pushes, a type of action which cannot be done with the current implementation of the keyboard shortcut action provided by Elgato by default, available in the System portion of the action list. 

As such, if the SuperMacro plugin isn't installed in your Stream Deck application, some actions of the first horizontal line will be represented by a small interrogation point and will only show the text "Super Macro".

## Usage
This plugin is intended to be used in a Pharo image, to quickly access some common keyboard shortcuts, often composed of three simultaneous button presses.
It is NOT associated to the Pharo launcher, which is to say that the actions this Stream Deck profile features will only be shown when the Pharo image associated to this profile is active.

### Changing the associated Pharo image
To change the associated Pharo image to this Stream Deck profile, simply open the Stream Deck application, click on the gear icon symbolizing the Settings, click the Profiles tab, then click the Pharo profile before clicking on the drop-down menu and selecting "Other...", being the last option of said list. A file explorer will open, prompting you to choose another .exe file.

Contrary to what could be thought at first glance, this Stream Deck profile doesn't point to a file with the extension .image, but to the virtual machine associated to said image, since the current implementation of Stream Deck profiles can only lead them to be associated to .exe files. These virtual machines are located by default in C:\Users\user\Documents\Pharo\vms\imageName\Pharo.exe

`imageName` having a name like 100-x64, or in regular expression terms (Regex): (0-9){3}-x64
