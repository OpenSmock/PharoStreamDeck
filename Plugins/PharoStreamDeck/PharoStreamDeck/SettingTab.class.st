"
For the Class part: I an action part of the PharoStreamDeck Plugin. The action associated with pressing my key is the opening of a setting tab in Pharo.

For the Responsibility part: my main responsability is to receive operations that were previously done on the JavaScript side of things. I receive data from it and if the action UUID is mine, I do my action.

**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin`` class.

**How to create instances:**
SettingTab new.

**Instances variables:**
webSocket: memorizes the in use websocket
receivedUUID: keeps in memory the UUID received when the plugin gets registered.
"
Class {
	#name : 'SettingTab',
	#superclass : 'SDSharedActions',
	#category : 'PharoStreamDeck-Tools',
	#package : 'PharoStreamDeck',
	#tag : 'Tools'
}

{ #category : 'action' }
SettingTab >> pluginAction [

	SettingBrowser open
]

{ #category : 'accessing' }
SettingTab >> receivedUUID: aUUID [

	receivedUUID := aUUID
]

{ #category : 'as yet unclassified' }
SettingTab >> uuidAction [

	^ 'com.thales.pharostreamdeck.settings'
]

{ #category : 'accessing' }
SettingTab >> webSocket: aWebSocket [

	webSocket := aWebSocket
]
