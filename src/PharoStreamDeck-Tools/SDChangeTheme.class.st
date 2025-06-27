"
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is the changing of UI theme in Pharo : dark theme or light theme.

**For the Responsibility part:** my main responsability is to receive operations that were previously done on the JavaScript side of things. I receive data from it and if the action UUID is mine, I do my action.

**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin`` class.

**How to create instances:**
_SDChangeTheme new._
"
Class {
	#name : 'SDChangeTheme',
	#superclass : 'SDSharedActions',
	#category : 'PharoStreamDeck-Tools',
	#package : 'PharoStreamDeck-Tools'
}

{ #category : 'action' }
SDChangeTheme >> pluginAction [
	"Action executed following a keyUp with the same uuid
	Changes the Pharo application theme, between dark and light themes"

	PharoDarkTheme isCurrent 
		ifTrue: [ PharoLightTheme beCurrent ] 
		ifFalse: [ PharoDarkTheme beCurrent ]
]

{ #category : 'accessing' }
SDChangeTheme >> uuidAction [
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.changetheme'
]
