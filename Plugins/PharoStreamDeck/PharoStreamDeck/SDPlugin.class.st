"
Represent a list of plugins where every plugin known each others.

Create instances:
'ArrayPlugin new'

Instance Variables :
- arrayPluginContents: <OrderedCollection>
- plugin:	 <Object>
"
Class {
	#name : 'SDPlugin',
	#superclass : 'Object',
	#category : 'PharoStreamDeck',
	#package : 'PharoStreamDeck'
}

{ #category : 'as yet unclassified' }
SDPlugin >> actionSelectorWitness: index [
	"puts in an array the names of the Selector and Witness actions for a plugin"

	| selector witness arrayPluginSelectorWitness |
	plugin := pluginList at: index.
	selector := plugin selectorAction.
	witness := plugin witnessAction.

	arrayPluginSelectorWitness := OrderedCollection new.
	arrayPluginSelectorWitness add: selector.
	arrayPluginSelectorWitness add: witness.
	^ arrayPluginSelectorWitness
]

{ #category : 'initialization' }
SDPlugin >> initialize [ 
]

{ #category : 'as yet unclassified' }
SDPlugin >> numberInAuthorizedNumbers: aNumber [
	"by using the authorizedNumbers: method of each plugin, determines which plugin is the one that needs its Witness values modified"

	| authorizedNumbers index foundNumber number |
	index := 0.
	foundNumber := false.
	number := aNumber asInteger.

	pluginList do: [ :each |
		index := index + 1.
		authorizedNumbers := each authorizedNumbers.
		(authorizedNumbers includes: number) ifTrue: [
			foundNumber := true.
			self plugin: (pluginList at: index) ] ].
	"a number has been found in one of the given arrays"
	foundNumber ifTrue: [ plugin pluginValue: number ]
]

{ #category : 'as yet unclassified' }
SDPlugin >> pluginSelectorSet [

	^ plugin pluginSelectorSet
]

{ #category : 'as yet unclassified' }
SDPlugin >> pluginValue [

	^ plugin pluginValue
]

{ #category : 'as yet unclassified' }
SDPlugin >> pluginWitnessSet [

	^ plugin pluginWitnessSet
]

{ #category : 'as yet unclassified' }
SDPlugin >> selectorAction [

	| arrayPluginSelector |
	arrayPluginSelector := OrderedCollection new.
	pluginList do: [ :each |
		arrayPluginSelector add: each selectorAction ].
	^ arrayPluginSelector
]

{ #category : 'as yet unclassified' }
SDPlugin >> selectorPercentAction [

	| percentPlugin |
	percentPlugin := pluginList at: 2.
	^ percentPlugin selectorAction
]

{ #category : 'as yet unclassified' }
SDPlugin >> selectorYearAction [

	| yearPlugin |
	yearPlugin := pluginList at: 1.
	^ yearPlugin selectorAction
]

{ #category : 'as yet unclassified' }
SDPlugin >> witnessAction [

	| arrayPluginWitness |
	arrayPluginWitness := OrderedCollection new.
	pluginList do: [ :each |
		arrayPluginWitness add: each witnessAction ].
	^ arrayPluginWitness
]
