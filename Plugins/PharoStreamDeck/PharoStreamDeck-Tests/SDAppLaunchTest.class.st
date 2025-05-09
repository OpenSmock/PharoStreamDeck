Class {
	#name : 'SDAppLaunchTest',
	#superclass : 'TestCase',
	#instVars : [
		'launch'
	],
	#category : 'PharoStreamDeck-Tests',
	#package : 'PharoStreamDeck-Tests'
}

{ #category : 'running' }
SDAppLaunchTest >> cleanUp [

	launch class arrayPlugin removeAll.
	launch := nil.
	self cleanUpInstanceVariables.

	"Put here a common initialization logic for tests"
]

{ #category : 'running' }
SDAppLaunchTest >> setUp [
	super setUp.
	launch := SDAppLaunch start.
	"Put here a common initialization logic for tests"
]

{ #category : 'tests' }
SDAppLaunchTest >> testWhichPlugin [
	"can't include a test which would test the communication between JavaScript and Pharo. The only way is to follow in order the data exchanges, starting with the Stream Deck to the plugin by launching the Stream Deck application after creating an instance of AppLaunch"

	| actionUUID actionName |
	actionUUID := 'com.thales.pharostreamdeck.playground'.
	actionName := launch class server.
	self
		assert: (actionName whichAction: actionUUID) class
		equals: PlaygroundTab.

	actionUUID := 'com.thales.pharostreamdeck.browsetab'.
	self
		assert: (actionName whichAction: actionUUID) class
		equals: SystemBrowseTab.
	self cleanUp
]
