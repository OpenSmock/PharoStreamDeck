"
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is browsing the implementors of a selected piece of code in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDBrowseImplementors new._
"
Class {
	#name : 'SDBrowseImplementors',
	#superclass : 'SDSharedActions',
	#category : 'PharoStreamDeck-Tools',
	#package : 'PharoStreamDeck-Tools'
}

{ #category : 'action' }
SDBrowseImplementors >> pluginAction [
	"Action executed following a keyUp with the same uuid"
	
	self currentWorld activeHand keyboardFocus handleKeyDown: 
	(KeyboardEvent new 
		setType: #keydown 
		buttons: KeyboardEvent ctrlKeyMask
		position: 0@0
		keyValue: $m asInteger 
		charCode: $m asInteger
		hand: self currentWorld activeHand 
		stamp: Time millisecondClockValue ;
		key: KeyboardKey M)
]

{ #category : 'accessing' }
SDBrowseImplementors >> uuidAction [
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.browseimplementors'
]
