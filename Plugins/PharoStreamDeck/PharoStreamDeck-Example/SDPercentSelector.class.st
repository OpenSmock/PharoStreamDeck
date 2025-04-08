Class {
	#name : 'SDPercentSelector',
	#superclass : 'PluginSharedActions',
	#instVars : [
		'valueSelector',
		'values'
	],
	#category : 'PharoStreamDeck-Example',
	#package : 'PharoStreamDeck-Example'
}

{ #category : 'intialization' }
SDPercentSelector >> initialize [

	super initialize.
	"percentWitnessSet := OrderedCollection new."
	"percentSelectorSet := OrderedCollection new."
	"arrayJSONSetTitleAndSettingsPercentWitness := OrderedCollection new."
	"percent := 50."
	
	valueSelector := SDValueSelector values: #(50 100 120 200) .
	values := valueSelector values.
	
]

{ #category : 'as yet unclassified' }
SDPercentSelector >> selectorAction [ 

	^ 'com.thales.pharostreamdeck.percentselector'
]

{ #category : 'as yet unclassified' }
SDPercentSelector >> valueSelector [

	^ valueSelector
]

{ #category : 'as yet unclassified' }
SDPercentSelector >> valueSelector: anObject [

	valueSelector := anObject
]

{ #category : 'accessing' }
SDPercentSelector >> values [

	^ values
]

{ #category : 'accessing' }
SDPercentSelector >> values: aListOfValues [

	values := aListOfValues
]

{ #category : 'as yet unclassified' }
SDPercentSelector >> witnessAction [ 

	^ 'com.thales.pharostreamdeck.percentwitness'
]
