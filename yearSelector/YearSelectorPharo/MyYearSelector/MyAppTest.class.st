Class {
	#name : #MyAppTest,
	#superclass : #TestCase,
	#instVars : [
		'year'
	],
	#category : #MyYearSelector
}

{ #category : #tests }
MyAppTest >> testAppInitialize [
"can't include a test which would test the communication between JavaScript and Pharo. The only way is to follow in order the data exchanges, starting with the Stream Deck to the plugin by launching the Stream Deck application after creating an instance of MyApp."

	| m |
	m := MyApp new.
	self assert: m year equals: 0.
	self assert: m percent equals: 50
]

{ #category : #tests }
MyAppTest >> testAppOtherValues [

	| m |
	m := MyApp new.
	m year: 10.
	self assert: m year equals: 10.
	m percent: 100.
	self assert: m percent equals: 100
]

{ #category : #tests }
MyAppTest >> testAppOtherValuesFailed [

	| m |
	m := MyApp new.
	m year: 32.
	"0 and 50 being the respective default values of YearSelector and PercentSelector"
	self assert: m year equals: 0.
	m percent: 32.
	self assert: m percent equals: 50
]

{ #category : #tests }
MyAppTest >> testDictionaryAtString [

	| d typeObj |
	d := Dictionary new.
	typeObj := 'year'.
	d at: typeObj put: 'year'.
	self assert: (d at: typeObj) equals: 'year'
]

{ #category : #tests }
MyAppTest >> testRegex [

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
MyAppTest >> testSameSubstring [

	| string |
	string := 'percent'.

	self assert: (string includesSubstring: 'percent').
]

{ #category : #tests }
MyAppTest >> testSubstringPharoStreamDeck [

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
