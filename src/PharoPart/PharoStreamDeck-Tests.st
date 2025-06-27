TestCase subclass: #SDPluginTest
	instanceVariableNames: 'instance'
	classVariableNames: ''
	package: 'PharoStreamDeck-Tests-Tests'!

!SDPluginTest methodsFor: 'running' stamp: '6/26/2025 15:53'!
setUp
	"Initializes the tests"

	super setUp.
	
	SDAppLaunch start.
	instance := SDAppLaunch server.! !

!SDPluginTest methodsFor: 'running' stamp: '6/26/2025 15:53'!
tearDown 
	"Cleans up the tests"

	super tearDown.
	
	SDAppLaunch cleanUp .
	self cleanUpInstanceVariables.! !


!SDPluginTest methodsFor: 'tests' stamp: '6/26/2025 15:54'!
testInitialize
	"Test of SDPlugin's initialization"

	self assert: instance webSocket equals: nil.
	self assert: instance serverStarted equals: nil.
	self assert: instance arrayTools size equals:17.! !

!SDPluginTest methodsFor: 'tests' stamp: '6/26/2025 15:54'!
testAccessing
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
	! !

!SDPluginTest methodsFor: 'tests' stamp: '6/16/2025 14:39'!
testKeyUpEvent
	"Test of keyUpEvent method"
	
	| temp |
	
	temp := Dictionary newFrom: {'action'->'com.thales.pharostreamdeck.playground'}.
	
	self assert: (instance keyUpEvent: temp) class equals: SDPlayground.
	
	
	! !

!SDPluginTest methodsFor: 'tests' stamp: '6/26/2025 15:55'!
testWhichAction
	"Test of whichAction method"

	| actionUUID |
	
	"Existing"
	actionUUID := 'com.thales.pharostreamdeck.playground'.
	self assert: (instance whichAction: actionUUID) class equals: SDPlayground.

	"Unknown"
	actionUUID := 'com.thales.pharostreamdeck.pharo'.
	self should: [instance whichAction: actionUUID class] raise: Error.
	! !


TestCase subclass: #SDToolTest
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tests-Tests'!

!SDToolTest methodsFor: 'as yet unclassified' stamp: '6/26/2025 15:56'!
testChangeTheme
	"Test the SDChangeTheme's action"

	| oldTheme newTheme plugin |
	plugin := SDChangeTheme new.
	oldTheme := Smalltalk ui theme.

	plugin pluginAction.
	newTheme := Smalltalk ui theme.

	self assert: oldTheme ~= newTheme! !


TestCase subclass: #SDAppLaunchTest
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tests-Tests'!

!SDAppLaunchTest methodsFor: 'tests' stamp: '6/26/2025 15:52'!
testAccessing
	"Verification of the values of the class accessors"
	
	"#arrayTools"
	self assert: SDAppLaunch arrayTools size equals: 17.
	self assert: (SDAppLaunch arrayTools first class) equals: SDChangeTheme.
	self assert: (SDAppLaunch arrayTools last class) equals: SDSystemBrowser.
	
	"#server"
	self assert: SDAppLaunch server class equals: SDPlugin.! !

!SDAppLaunchTest methodsFor: 'tests' stamp: '6/26/2025 15:52'!
testCleanUp
	"Tests of cleanUp method"
	
	"Before"
	self assert: SDAppLaunch arrayTools size equals: 17.
	self assert: SDAppLaunch server class equals: SDPlugin.
	
	"After"
	SDAppLaunch cleanUp .
	self assert: SDAppLaunch arrayTools equals: nil.
	self assert: SDAppLaunch server equals: nil.! !


!SDAppLaunchTest methodsFor: 'running' stamp: '6/26/2025 15:52'!
setUp
	"Initializes the tests"

	super setUp.
	
	SDAppLaunch start.! !

!SDAppLaunchTest methodsFor: 'running' stamp: '6/26/2025 15:52'!
tearDown 
	"Cleans up the tests"

	super tearDown.
	
	SDAppLaunch cleanUp .
	self cleanUpInstanceVariables.! !
