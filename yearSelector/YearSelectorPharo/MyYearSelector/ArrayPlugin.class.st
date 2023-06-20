"
For the Class part:  I represent an array of plugins, so that every plugin is aware of the existence of the other plugins launched.

For the Responsibility part: I stock in my unique instance variable the different plugins, so that it's possible to change which one is referenced, which Witness instances' value need to be changed

For the Collaborators Part: PluginSharedActions and its subclasses

How to create instances:
ArrayPlugin new

    Instance Variables
	arrayPluginContents:		<OrderedCollection>
"
Class {
	#name : #ArrayPlugin,
	#superclass : #Object,
	#instVars : [
		'arrayPluginContents',
		'plugin'
	],
	#category : #MyYearSelector
}

{ #category : #accessing }
ArrayPlugin >> arrayJSONSetTitleAndSettingsPluginWitness [

	^ plugin arrayJSONSetTitleAndSettingsPluginWitness
]

{ #category : #initialization }
ArrayPlugin >> arrayPluginContents [

	^ arrayPluginContents
]

{ #category : #initialization }
ArrayPlugin >> initialize [

	arrayPluginContents := OrderedCollection new: 2.
]

{ #category : #accessing }
ArrayPlugin >> numberInAuthorizedNumbers: aNumber [
	"by using the authorizedNumbers:  method of each plugin, determines which plugin is the one that needs its Witness values modified"

	| authorizedNumbers index foundNumber |
	index := 0.
	foundNumber := false.
	
	arrayPluginContents do: [ :each |
		index := index + 1.
		authorizedNumbers := each authorizedNumbers.
		(authorizedNumbers includes: aNumber) ifTrue: [
			foundNumber := true.
			self plugin: (arrayPluginContents at: index) ] ].
			"changes the current plugin value for every launched plugin"
			"arrayPlugin do: [ :e | e plugin: (arrayPlugin at: index) ] ] ]."
	"a number has been found in one of the given arrays"
	foundNumber ifTrue: [ self plugin pluginValue: aNumber ]
]

{ #category : #accessing }
ArrayPlugin >> plugin [

	^ plugin
]

{ #category : #accessing }
ArrayPlugin >> plugin: aPlugin [

	plugin := aPlugin
]

{ #category : #accessing }
ArrayPlugin >> pluginSelectorSet [

	^ plugin pluginSelectorSet
]

{ #category : #accessing }
ArrayPlugin >> pluginValue [

	^ plugin pluginValue
]

{ #category : #accessing }
ArrayPlugin >> pluginWitnessSet [

	^ plugin pluginWitnessSet
]

{ #category : #accessing }
ArrayPlugin >> selectorAction [

	^ plugin selectorAction
]

{ #category : #accessing }
ArrayPlugin >> witnessAction [

	^ plugin witnessAction
]
