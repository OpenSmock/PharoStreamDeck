Class {
	#name : 'AppLaunchTest',
	#superclass : 'TestCase',
	#category : 'PharoStreamDeck-Tests',
	#package : 'PharoStreamDeck-Tests'
}

{ #category : 'tests' }
AppLaunchTest >> testAppInitialize [
	"can't include a test which would test the communication between JavaScript and Pharo. The only way is to follow in order the data exchanges, starting with the Stream Deck to the plugin by launching the Stream Deck application after creating an instance of AppLaunch"

	| a |
	a := AppLaunch new.
	self assert: a year equals: 0.
	self assert: a percent equals: 50
]

{ #category : 'tests' }
AppLaunchTest >> testAppOtherValues [

	| a |
	a := AppLaunch new.
	a year: 10.
	self assert: a year equals: 10.
	a percent: 100.
	self assert: a percent equals: 100
]

{ #category : 'tests' }
AppLaunchTest >> testAppOtherValuesFailed [

	| a |
	a := MyApp new.
	a year: 32.
	"0 and 50 being the respective default values of YearSelector and PercentSelector"
	self assert: a year equals: 0.
	a percent: 32.
	self assert: a percent equals: 50
]

{ #category : 'tests' }
AppLaunchTest >> testNumberInAuthorizedNumbers [
	"modifying the selected plugin changes the selected plugin for every plugin"

	| a arrayPluginContents yearSelector percentSelector plugin |
	a := AppLaunch new.

	arrayPluginContents := a myApp arrayPlugin arrayPluginContents.
	yearSelector := arrayPluginContents at: 1.
	percentSelector := arrayPluginContents at: 2.
	plugin := a myApp arrayPlugin.
	plugin numberInAuthorizedNumbers: 10.

	self
		assert: yearSelector arrayPlugin plugin
		equals: percentSelector arrayPlugin plugin
]
