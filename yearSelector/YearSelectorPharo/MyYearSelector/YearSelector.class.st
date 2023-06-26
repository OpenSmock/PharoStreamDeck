"
For the Class part: I represent a year selector, with values being specific integers (1, 5, 10, 15, 20) defined in the yearSelector_pi.html file.

For the Responsibility part: my main responsability is to handle operations that were previously done on the JavaScript side of things. Through a second WebSocket, this class can interact with the Elgato Stream Deck. As such, values can only be chosen through button presses on the Stream Deck through the use of this class alone (see PharoPlugin Stream Deck profile).

For the Collaborators part: my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin.

How to create instances:
YearSelector new.

Instance variables: 
yearSelectorSet (memorizes every instance of a YearSelector through their context)
yearWitnessSet (memorizes every instance of a YearWitness through their context)
year (the plugin value)
arrayJSONSetTitleAndSettingsYearWitness (used to send setTitle and setSettings events to keep track of the values shown and saved)
"
Class {
	#name : #YearSelector,
	#superclass : #PluginSharedActions,
	#instVars : [
		'yearWitnessSet',
		'yearSelectorSet',
		'year',
		'arrayJSONSetTitleAndSettingsYearWitness'
	],
	#category : #MyYearSelector
}

{ #category : #accessing }
YearSelector >> arrayJSONSetTitleAndSettingsPluginWitness [

	^ arrayJSONSetTitleAndSettingsYearWitness
]

{ #category : #accessing }
YearSelector >> authorizedNumbers [
	"these numbers are the only values permitted to be taken by a YearSelector through its Property Inspector, defined in yearSelector_pi.html"
	^ #( 0 5 10 15 20 )
]

{ #category : #accessing }
YearSelector >> initialize [

	super initialize.
	yearWitnessSet := OrderedCollection new.
	yearSelectorSet := OrderedCollection new.
	arrayJSONSetTitleAndSettingsYearWitness := OrderedCollection new.
	year := 0
]

{ #category : #accessing }
YearSelector >> pluginSelectorSet [

	^ yearSelectorSet
]

{ #category : #accessing }
YearSelector >> pluginValue [

	^ year
]

{ #category : #initialization }
YearSelector >> pluginValue: aYear [

	year := aYear.
	"also updates the GUI value" 
	pharostreamdeck year: aYear.
]

{ #category : #accessing }
YearSelector >> pluginWitnessSet [

	^ yearWitnessSet
]

{ #category : #events }
YearSelector >> selectorAction [ 

	^ 'com.thales.pharostreamdeck.yearselector'
]

{ #category : #accessing }
YearSelector >> witnessAction [ 

	^ 'com.thales.pharostreamdeck.yearwitness'
]
