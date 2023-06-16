"
For the Class part: I represent a year selector, with values being specific integers (1, 5, 10, 15, 20) defined in the yearSelector_pi.html file.

For the Responsibility part: my main responsability is to handle operations that were previously done on the JavaScript side of things. Through a second WebSocket, this class can interact with the Elgato Stream Deck. As such, values can only be chosen through button presses on the Stream Deck through the use of this class alone (see PharoPlugin Stream Deck profile).

For the Collaborators part: my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on their grids through the YearSelector plugin.

How to create instances:
YearSelector new.

Instance variables: 
year is the year value shown on the YearWitness instances
uuid is the unique value identifying the plugin (inPluginUUID in JavaScript code). It's sent via the registration procedure, so recuperated from the connectElgatoStreamDeckSocket() function (https://developer.elgato.com/documentation/stream-deck/sdk/registration-procedure/#compiled-plugin-registration) and is used in the setGlobalSettings: method for its context field, since globalSettings events require more than a context value to share a setting between instances of the plugin (see SDK documentation - events sent https://developer.elgato.com/documentation/stream-deck/sdk/events-sent/#setglobalsettings)
yearWitnessSet memorizes the context of every YearWitness instance, so that it can update them whenever a YearSelector instance is pressed. It's refilled every time the willAppear event is triggered, so when the YearSelectorPharo profile is the profile shown on the Stream Deck, for example
arrayJsonSetTitleAndSettingsYearWitness stocks the setTitle events that need to be sent to the plugin in order to update every YearWitness instance to showw the correct value pressed. It uses yearWitnessSet to know which Stream Deck keys are YearWitness instances
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

	year := aYear
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

{ #category : #initialization }
YearSelector >> year [

	^ year
]
