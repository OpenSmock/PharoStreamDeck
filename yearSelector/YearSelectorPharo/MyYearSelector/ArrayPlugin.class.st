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
