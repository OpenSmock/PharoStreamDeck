Class {
	#name : 'SDPluginTest',
	#superclass : 'TestCase',
	#instVars : [
		'instance'
	],
	#category : 'PharoStreamDeck-Tests',
	#package : 'PharoStreamDeck-Tests'
}

{ #category : 'running' }
SDPluginTest >> setUp [
	"Initializes the tests"

	super setUp.
	
	SDAppLaunch start.
	instance := SDAppLaunch server.
]

{ #category : 'running' }
SDPluginTest >> tearDown [ 
	"Cleans up the tests"

	super tearDown.
	
	SDAppLaunch cleanUp .
	self cleanUpInstanceVariables.
]

{ #category : 'tests' }
SDPluginTest >> testAccessing [
	"Verification of the values of the instance's accessors"
	
	"#webSocket"
	instance serverStarted: true.
	self assert: instance serverStarted equals: true.
	
	"#serverStarted"
	instance webSocket: ZnWebSocket new.
	self assert: instance webSocket class equals: ZnWebSocket.
	
	"#arrayTools"
	self assert: instance arrayTools size equals: 17.
	self assert: (instance arrayTools first class) equals: SDChangeTheme.
	self assert: (instance arrayTools last class) equals: SDSystemBrowser.
	
	"uuid"
	self assert: instance uuid equals: 'com.thales.pharostreamdeck'.
	
]

{ #category : 'tests' }
SDPluginTest >> testInitialize [
	"Test of SDPlugin's initialization"

	self assert: instance webSocket equals: nil.
	self assert: instance serverStarted equals: nil.
	self assert: instance arrayTools size equals:17.
]

{ #category : 'tests' }
SDPluginTest >> testKeyUpEvent [
	"Test of keyUpEvent method"
	
	| temp |
	
	temp := Dictionary newFrom: {'action'->'com.thales.pharostreamdeck.playground'}.
	
	self assert: (instance keyUpEvent: temp) class equals: SDPlayground.
	
	
	
]

{ #category : 'tests' }
SDPluginTest >> testWhichAction [
	"Test of whichAction method"

	| actionUUID |
	
	"Existing"
	actionUUID := 'com.thales.pharostreamdeck.playground'.
	self assert: (instance whichAction: actionUUID) class equals: SDPlayground.

	"Unknown"
	actionUUID := 'com.thales.pharostreamdeck.pharo'.
	self should: [instance whichAction: actionUUID class] raise: Error.
	
]
