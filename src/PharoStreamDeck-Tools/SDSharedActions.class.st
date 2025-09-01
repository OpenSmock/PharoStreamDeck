"
**For the Class part:** I regroup methods common to every tools of my StreamDeck plugin. I am abstract, therefore, there is no utility in creating an instance of myself. 

See my subclasses for more information.


"
Class {
	#name : 'SDSharedActions',
	#superclass : 'Object',
	#category : 'PharoStreamDeck-Tools',
	#package : 'PharoStreamDeck-Tools'
}

{ #category : 'environment' }
SDSharedActions >> ctrlOrCmdKeyMask [

	Smalltalk os current isMacOS | Smalltalk os current isMacOSX ifTrue: [ ^ KeyboardEvent cmdKeyMask ].
	^ KeyboardEvent ctrlKeyMask
]

{ #category : 'action' }
SDSharedActions >> pluginAction [
	"Action executed following a keyUp with the same uuid"

	self subclassResponsibility
]

{ #category : 'accessing' }
SDSharedActions >> uuidAction [
	"Returns the action unique identifier"

	self subclassResponsibility
]
