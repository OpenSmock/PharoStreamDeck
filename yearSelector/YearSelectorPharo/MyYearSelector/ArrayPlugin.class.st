"
For the Class part:  I represent an array of plugins, so that every plugin is aware of the existence of the other plugins launched.

For the Responsibility part: I stock in arrayPluginContents  the different plugins and in plugin the currently selected plugin so that it's possible to change which one is referenced, which Witness instances' plugin value need to be changed

For the Collaborators Part: PluginSharedActions and its subclasses

How to create instances:
ArrayPlugin new

    Instance Variables
	arrayPluginContents:		<OrderedCollection>
	plugin:			<Object>
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
ArrayPlugin >> actionSelectorWitness: index [

	| selector witness arrayPluginSelectorWitness |
	plugin := arrayPluginContents at: index.
	selector := plugin selectorAction.
	witness := plugin witnessAction.

	arrayPluginSelectorWitness := OrderedCollection new.
	arrayPluginSelectorWitness add: selector.
	self inform: selector.
	arrayPluginSelectorWitness add: witness.
	self inform: witness.
	^ arrayPluginSelectorWitness
]

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
ArrayPlugin >> percentAction [

	| percentPlugin pluginSelector pluginWitness arrayPluginPercentSelectorWitness |
	percentPlugin := arrayPluginContents at: 2.
	pluginSelector := percentPlugin selectorAction.
	pluginWitness := percentPlugin witnessAction.

	arrayPluginPercentSelectorWitness := OrderedCollection new.
	arrayPluginPercentSelectorWitness add: pluginSelector.
	arrayPluginPercentSelectorWitness add: pluginWitness.
	^ arrayPluginPercentSelectorWitness
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

	| arrayPluginSelector |
	arrayPluginSelector := OrderedCollection new.
	arrayPluginContents do: [ :each |
		arrayPluginSelector add: each witnessAction ].
	^ arrayPluginSelector
]

{ #category : #accessing }
ArrayPlugin >> selectorPercentAction [

	| percentPlugin |
	percentPlugin := arrayPluginContents at: 2.
	^ percentPlugin selectorAction
]

{ #category : #accessing }
ArrayPlugin >> selectorYearAction [

	| yearPlugin |
	yearPlugin := arrayPluginContents at: 1.
	^ yearPlugin selectorAction
]

{ #category : #accessing }
ArrayPlugin >> witnessAction [

	| arrayPluginWitness |
	arrayPluginWitness := OrderedCollection new.
	arrayPluginContents do: [ :each |
		arrayPluginWitness add: each witnessAction ].
	^ arrayPluginWitness
]
