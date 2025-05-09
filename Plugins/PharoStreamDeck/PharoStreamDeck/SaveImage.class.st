"
**For the Class part:** I am an action part of the PharoStreamDeck Plugin. The action associated with pressing my key is saving the current image in Pharo.

**For the Responsibility part:** my main responsability is to receive operations that were previously done on the JavaScript side of things. I receive data from it and if the action UUID is mine, I do my action.

**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin`` class.

**How to create instances:**
SaveImage new.

**Instances variables:**
webSocket: memorizes the in use websocket
receivedUUID: keeps in memory the UUID received when the plugin gets registered.
"
Class {
	#name : 'SaveImage',
	#superclass : 'SDSharedActions',
	#category : 'PharoStreamDeck-Tools',
	#package : 'PharoStreamDeck',
	#tag : 'Tools'
}

{ #category : 'action' }
SaveImage >> pluginAction [

	(Smalltalk snapshot: true andQuit: false) hasSavedSuccessfully
				ifTrue: [ self inform: 'Image saved' ]
]

{ #category : 'accessing' }
SaveImage >> receivedUUID: aUUID [

	receivedUUID := aUUID
]

{ #category : 'as yet unclassified' }
SaveImage >> uuidAction [

	^ 'com.thales.pharostreamdeck.saveimage'
]

{ #category : 'accessing' }
SaveImage >> webSocket: aWebSocket [

	webSocket := aWebSocket
]
