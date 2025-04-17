"
For the Class part: I represent a year selector, with values being specific integers (1, 5, 10, 15, 20) defined in the yearSelector_pi.html file.

For the Responsibility part: my main responsability is to handle operations that were previously done on the JavaScript side of things. Through a second WebSocket, this class can interact with the Elgato Stream Deck. As such, values can only be chosen through button presses on the Stream Deck through the use of this class alone (see PharoStreamDeck profile).

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
	#name : 'BrowseTab',
	#superclass : 'PluginSharedActions',
	#instVars : [
		'yearWitnessSet',
		'yearSelectorSet',
		'year',
		'arrayJSONSetTitleAndSettingsYearWitness'
	],
	#category : 'PharoStreamDeck-Tools',
	#package : 'PharoStreamDeck',
	#tag : 'Tools'
}

{ #category : 'accessing' }
BrowseTab >> arrayJSONSetTitleAndSettingsPluginWitness [

	^ arrayJSONSetTitleAndSettingsYearWitness
]

{ #category : 'accessing' }
BrowseTab >> pluginAction [

	ToolRegistry new openClassBrowser 
]

{ #category : 'accessing' }
BrowseTab >> pluginSelectorSet [

	^ yearSelectorSet
]

{ #category : 'accessing' }
BrowseTab >> pluginValue [

	^ year
]

{ #category : 'initialization' }
BrowseTab >> pluginValue: aYear [

	year := aYear.
	"also updates the GUI value" 
	pharostreamdeck year: aYear.
]

{ #category : 'accessing' }
BrowseTab >> pluginWitnessSet [

	^ yearWitnessSet
]

{ #category : 'events' }
BrowseTab >> selectorAction [ 

	^ 'com.thales.pharostreamdeck.browsetabselector'
]

{ #category : 'accessing' }
BrowseTab >> uuidAction [

	^ 'com.thales.pharostreamdeck.browsetab'
]

{ #category : 'accessing' }
BrowseTab >> witnessAction [ 

	^ 'com.thales.pharostreamdeck.browsetabwitness'
]
