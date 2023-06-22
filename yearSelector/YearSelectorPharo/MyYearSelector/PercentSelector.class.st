"
For the Class part: I represent a percent selector, with values being specific integers (50, 100, 150, 200) defined in the percentSelector_pi.html file.

For the Responsibility part: my main responsability is to handle operations that were previously done on the JavaScript side of things. Through a second WebSocket, this class can interact with the Elgato Stream Deck. As such, values can only be chosen through button presses on the Stream Deck through the use of this class alone (see PharoPlugin Stream Deck profile).

For the Collaborators part: my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on their grids through the YearSelector plugin.

How to create instances:
PercentSelector new.

Instance variables: 
percentSelectorSet (memorizes every instance of a PercentSelector through their context)
percentWitnessSet (memorizes every instance of a PercentWitness through their context)
percent (the plugin value)
arrayJSONSetTitleAndSettingsPercentWitness (used to send setTitle and setSettings events to keep track of the values shown and saved)
"
Class {
	#name : #PercentSelector,
	#superclass : #PluginSharedActions,
	#instVars : [
		'percentSelectorSet',
		'percentWitnessSet',
		'percent',
		'arrayJSONSetTitleAndSettingsPercentWitness'
	],
	#category : #MyYearSelector
}

{ #category : #initialization }
PercentSelector >> arrayJSONSetTitleAndSettingsPluginWitness [

	^ arrayJSONSetTitleAndSettingsPercentWitness
]

{ #category : #initialization }
PercentSelector >> authorizedNumbers [
	"these numbers are the only values permitted to be taken by a PercentSelector through its Property Inspector, defined in percentSelector_pi.html"
	^  #( 50 100 150 200 )
]

{ #category : #initialization }
PercentSelector >> initialize [

	super initialize.
	percentWitnessSet := OrderedCollection new.
	percentSelectorSet := OrderedCollection new.
	arrayJSONSetTitleAndSettingsPercentWitness := OrderedCollection new.
	percent := 50
]

{ #category : #initialization }
PercentSelector >> pluginSelectorSet [

	^ percentSelectorSet
]

{ #category : #initialization }
PercentSelector >> pluginValue [

	^ percent
]

{ #category : #initialization }
PercentSelector >> pluginValue: aPercent [

	percent := aPercent.
	"also updates the GUI value" 
	pharostreamdeck percent: aPercent.
]

{ #category : #initialization }
PercentSelector >> pluginWitnessSet [

	^ percentWitnessSet
]

{ #category : #initialization }
PercentSelector >> selectorAction [ 

	^ 'com.thales.pharostreamdeck.percentselector'
]

{ #category : #initialization }
PercentSelector >> witnessAction [ 

	^ 'com.thales.pharostreamdeck.percentwitness'
]
