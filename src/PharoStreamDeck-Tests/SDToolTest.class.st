Class {
	#name : 'SDToolTest',
	#superclass : 'TestCase',
	#category : 'PharoStreamDeck-Tests',
	#package : 'PharoStreamDeck-Tests'
}

{ #category : 'as yet unclassified' }
SDToolTest >> testChangeTheme [
	"Test the SDChangeTheme's action"

	| oldTheme newTheme plugin |
	plugin := SDChangeTheme new.
	oldTheme := Smalltalk ui theme.

	plugin pluginAction.
	newTheme := Smalltalk ui theme.

	self assert: oldTheme ~= newTheme
]
