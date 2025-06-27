Class {
	#name : 'SDAppLaunchTest',
	#superclass : 'TestCase',
	#category : 'PharoStreamDeck-Tests',
	#package : 'PharoStreamDeck-Tests'
}

{ #category : 'running' }
SDAppLaunchTest >> setUp [
	"Initializes the tests"

	super setUp.
	
	SDAppLaunch start.
]

{ #category : 'running' }
SDAppLaunchTest >> tearDown [ 
	"Cleans up the tests"

	super tearDown.
	
	SDAppLaunch cleanUp .
	self cleanUpInstanceVariables.
]

{ #category : 'tests' }
SDAppLaunchTest >> testAccessing [
	"Verification of the values of the class accessors"
	
	"#arrayTools"
	self assert: SDAppLaunch arrayTools size equals: 17.
	self assert: (SDAppLaunch arrayTools first class) equals: SDChangeTheme.
	self assert: (SDAppLaunch arrayTools last class) equals: SDSystemBrowser.
	
	"#server"
	self assert: SDAppLaunch server class equals: SDPlugin.
]

{ #category : 'tests' }
SDAppLaunchTest >> testCleanUp [
	"Tests of cleanUp method"
	
	"Before"
	self assert: SDAppLaunch arrayTools size equals: 17.
	self assert: SDAppLaunch server class equals: SDPlugin.
	
	"After"
	SDAppLaunch cleanUp .
	self assert: SDAppLaunch arrayTools equals: nil.
	self assert: SDAppLaunch server equals: nil.
]
