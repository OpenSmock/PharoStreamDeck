Class {
	#name : #AppLaunchTest,
	#superclass : #TestCase,
	#category : #MyYearSelector
}

{ #category : #tests }
AppLaunchTest >> testAppInitialize [
	"can't include a test which would test the communication between JavaScript and Pharo. The only way is to follow in order the data exchanges, starting with the Stream Deck to the plugin by launching the Stream Deck application after creating an instance of AppLaunch"

	| a |
	a := AppLaunch new.
	self assert: a year equals: 0.
	self assert: a percent equals: 50
]

{ #category : #tests }
AppLaunchTest >> testAppOtherValues [

	| a |
	a := AppLaunch new.
	a year: 10.
	self assert: a year equals: 10.
	a percent: 100.
	self assert: a percent equals: 100
]

{ #category : #tests }
AppLaunchTest >> testAppOtherValuesFailed [

	| a |
	a := MyApp new.
	a year: 32.
	"0 and 50 being the respective default values of YearSelector and PercentSelector"
	self assert: a year equals: 0.
	a percent: 32.
	self assert: a percent equals: 50
]

{ #category : #tests }
AppLaunchTest >> testDictionaryAtString [

	| d typeObj |
	d := Dictionary new.
	typeObj := 'year'.
	d at: typeObj put: 'year'.
	self assert: (d at: typeObj) equals: 'year'
]

{ #category : #tests }
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

{ #category : #tests }
AppLaunchTest >> testRegex [

	| string |
	string := 'heeo'.
	self assert: (string matchesRegex: 'heeo').
	self assert: (string matchesRegex: 'h.*o').
	self assert: (string matchesRegex: 'h.*o').
	
	"regex can't find a substring, use findString: instead"
	"can't find string with a syntax like *year* or (year)*"
	self deny: (string matchesRegex: 'ho')
]

{ #category : #tests }
AppLaunchTest >> testSameSubstring [

	| string |
	string := 'percent'.

	self assert: (string includesSubstring: 'percent').
]

{ #category : #tests }
AppLaunchTest >> testSubstringPharoStreamDeck [

	| string string2 string3 string4 |
	string := 'com.thales.pharostreamdeck.yearselector'.
	string2 := 'com.thales.pharostreamdeck.yearwitness'.
	string3 := 'com.thales.pharostreamdeck.percentselector'.
	string4 := 'com.thales.pharostreamdeck.percentwitness'.

	self assert: (string includesSubstring: 'year').
	self assert: (string includesSubstring: 'selector').
	self assert: (string2 includesSubstring: 'year').
	self assert: (string2 includesSubstring: 'witness').
	self assert: (string3 includesSubstring: 'percent').
	self assert: (string3 includesSubstring: 'selector').
	self assert: (string4 includesSubstring: 'percent').
	self assert: (string4 includesSubstring: 'witness')
]
