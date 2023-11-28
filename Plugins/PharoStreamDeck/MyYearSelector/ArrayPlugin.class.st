"
For the Class part: I represent an array of plugins, so that every plugin is aware of the existence of the other plugins launched.

For the Responsibility part: I stock in arrayPluginContents the different plugins and in plugin the currently selected plugin. This is done in order to change which one is referenced, which Witness instances' plugin value need to be changed

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
	"puts in an array the names of the Selector and Witness actions for a plugin"

	| selector witness arrayPluginSelectorWitness |
	plugin := arrayPluginContents at: index.
	selector := plugin selectorAction.
	witness := plugin witnessAction.

	arrayPluginSelectorWitness := OrderedCollection new.
	arrayPluginSelectorWitness add: selector.
	arrayPluginSelectorWitness add: witness.
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
	"by using the authorizedNumbers: method of each plugin, determines which plugin is the one that needs its Witness values modified"

	| authorizedNumbers index foundNumber number |
	index := 0.
	foundNumber := false.
	number := aNumber asInteger.

	arrayPluginContents do: [ :each |
		index := index + 1.
		authorizedNumbers := each authorizedNumbers.
		(authorizedNumbers includes: number) ifTrue: [
			foundNumber := true.
			self plugin: (arrayPluginContents at: index) ] ].
	"a number has been found in one of the given arrays"
	foundNumber ifTrue: [ plugin pluginValue: number ]
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
		arrayPluginSelector add: each selectorAction ].
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
