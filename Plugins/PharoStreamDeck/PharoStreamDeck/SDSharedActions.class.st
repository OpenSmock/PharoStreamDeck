"
**For the Class part:** I regroup methods common to every action of my plugin. I am abstract, therefore, there is no utility in creating an instance of myself. 


"
Class {
	#name : 'SDSharedActions',
	#superclass : 'Object',
	#instVars : [
		'receivedUUID',
		'webSocket'
	],
	#category : 'PharoStreamDeck-Tools',
	#package : 'PharoStreamDeck',
	#tag : 'Tools'
}

{ #category : 'testing' }
SDSharedActions class >> isAbstract [

	^ self == SDSharedActions
]

{ #category : 'action' }
SDSharedActions >> pluginAction [

	self subclassResponsibility
]

{ #category : 'accessing' }
SDSharedActions >> uuidAction [

	self subclassResponsibility
]

{ #category : 'accessing' }
SDSharedActions >> webSocket: aWebSocket [

	self subclassResponsibility
]
