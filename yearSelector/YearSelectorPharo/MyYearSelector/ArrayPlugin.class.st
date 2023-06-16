Class {
	#name : #ArrayPlugin,
	#superclass : #Object,
	#instVars : [
		'arrayPluginContents'
	],
	#category : #MyYearSelector
}

{ #category : #initialization }
ArrayPlugin >> arrayPluginContents [

	^ arrayPluginContents
]

{ #category : #initialization }
ArrayPlugin >> initialize [

	arrayPluginContents := OrderedCollection new: 2.
]
