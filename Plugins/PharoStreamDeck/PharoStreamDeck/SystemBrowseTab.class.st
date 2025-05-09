"
**For the Class part:** I an action part of the PharoStreamDeck Plugin. The action associated with pressing my key is the opening of a System Browser tab in Pharo.

**For the Responsibility part:** my main responsability is to handle operations that were previously done on the JavaScript side of things. I receive data from it and if the action UUID is mine, I do my action. 

**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
SystemBrowseTab new.


"
Class {
	#name : 'SystemBrowseTab',
	#superclass : 'SDSharedActions',
	#category : 'PharoStreamDeck-Tools',
	#package : 'PharoStreamDeck',
	#tag : 'Tools'
}

{ #category : 'action' }
SystemBrowseTab >> pluginAction [

	ToolRegistry new openClassBrowser 
]

{ #category : 'accessing' }
SystemBrowseTab >> receivedUUID: aUUID [

	receivedUUID := aUUID
]

{ #category : 'as yet unclassified' }
SystemBrowseTab >> uuidAction [

	^ 'com.thales.pharostreamdeck.systembrowse'
]

{ #category : 'accessing' }
SystemBrowseTab >> webSocket: aWebSocket [

	webSocket := aWebSocket
]
