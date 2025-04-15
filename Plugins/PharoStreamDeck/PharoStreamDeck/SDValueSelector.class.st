Class {
	#name : 'SDValueSelector',
	#superclass : 'Object',
	#instVars : [
		'label',
		'values'
	],
	#category : 'PharoStreamDeck-Tool',
	#package : 'PharoStreamDeck',
	#tag : 'Tool'
}

{ #category : 'initialization' }
SDValueSelector class >> values: aListOfValues [
	^ self new
		values: aListOfValues ;
		yourself
]

{ #category : 'initialization' }
SDValueSelector >> initialize [

	super initialize .
	values := OrderedCollection new.
]

{ #category : 'accessing' }
SDValueSelector >> label [

	^ label
]

{ #category : 'accessing' }
SDValueSelector >> label: aSelectorName [

	label := aSelectorName
]

{ #category : 'accessing' }
SDValueSelector >> values [

	^ values
]

{ #category : 'accessing' }
SDValueSelector >> values: aListOfValue [

	values := aListOfValue asOrderedCollection .
]
