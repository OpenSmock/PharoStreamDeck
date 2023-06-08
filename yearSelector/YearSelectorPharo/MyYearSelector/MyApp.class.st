"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: I contain the YearSelector class by using methods that can directly modify its state, such as the year selected.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	plugin:		<Object>
	year:		<Object>


    Implementation Points
"
Class {
	#name : #MyApp,
	#superclass : #Object,
	#instVars : [
		'plugin',
		'year',
		'arrayGetSettings',
		'arraySetImage'
	],
	#category : #MyYearSelector
}

{ #category : #initialization }
MyApp >> authorizedNumbers [

	"these numbers are the only values permitted to be taken by a YearSelector through its Property Inspector, defined in yearSelector_pi.html"

	^ #( 0 5 10 15 20 )
]

{ #category : #initialization }
MyApp >> highlightYearSelectorReceive: jsonObj [

	"highlight YearSelector values with the chosen (valid value since checked in year: ) year value"

	"uses yearSelectorSet which saves every context of every YearSelector action present on the current Stream Deck profile shown to know which buttons should be highlighted when this method is called. It also resets previous keys that were highlighted."

	"It also implies that multiple YearSelector actions can be selected, which is not possible while pressing keys on the Stream Deck"

	"context is linked to a year value by the getSettings event which makes the plugin receive a didReceiveSettings event transmitting the year value, which is updated if keyUp: is triggered"

	"receives multiple times the same event, no need for a do: loop"

	| yearObj defaultImage highlightedImage context jsonDefaultImage jsonHighlightedImage jsonImage |
	defaultImage := 'img/actionIcon.png'.
	highlightedImage := 'img/actionIconHighlighted.png'.
	arraySetImage := OrderedCollection new.
	
	context := jsonObj at: 'context'.
	yearObj := (jsonObj at: 'payload' at: 'settings' at: 'settings') at: 'year'.

	"sets the new blue background"
	yearObj = year ifTrue: [ 
		jsonHighlightedImage := Dictionary new
			                        at: 'context' put: context;
			                        at: 'image' put: highlightedImage;
			                        yourself.

		jsonImage := plugin setImage: jsonHighlightedImage.
		arraySetImage add: jsonImage ].

	"resets the background to its original black"
	yearObj = year ifFalse: [ 
		jsonDefaultImage := Dictionary new
			                    at: 'context' put: context;
			                    at: 'image' put: defaultImage;
			                    yourself.

		jsonImage := plugin setImage: jsonDefaultImage.
		arraySetImage add: jsonImage ].

	self sendGetImage: plugin WebSocket
]

{ #category : #initialization }
MyApp >> highlightYearSelectorSend [

	"highlight YearSelector values with the chosen (valid value since checked in year: ) year value"

	"uses yearSelectorSet which saves every context of every YearSelector action present on the current Stream Deck profile shown to know which buttons should be highlighted when this method is called"

	"It also implies that multiple YearSelector actions can be selected, which is not possible while pressing keys on the Stream Deck"

	"context is linked to a year value by the getSettings event (multiple instances of the event are sent through arrayGetSettings) which makes the plugin receive a didReceiveSettings event transmitting the year value, which is updated if keyUp: is triggered"

	| jsonSettings |
	plugin yearSelectorSet do: [ :each | 
		jsonSettings := plugin getSettings: each.
		arrayGetSettings add: jsonSettings.
		self sendGetSettings: plugin WebSocket ]
]

{ #category : #initialization }
MyApp >> initPlugin: myAppInstance [

	"also triggers myAppInitialize in the YearSelector class so that YearSelector can access the methods of MyApp (highlightYearSelectorReceive: notably) without having YearSelector dependent on MyApp (aggregation link, YearSelector can still be launched alone, see GitHub diagram)"

	plugin := YearSelector new.
	plugin myAppInitialize: myAppInstance
]

{ #category : #initialization }
MyApp >> initialize [

	year := 0.
	arrayGetSettings := OrderedCollection new.
	arraySetImage := OrderedCollection new.
	
	self initPlugin: self
]

{ #category : #initialization }
MyApp >> modifyYearWitnessValue [

	"this method is used to change every YearWitness instance's value"

	| json |
	json := Dictionary new
		        at: 'year' put: year;
		        yourself.
	plugin getGlobalSettings: json
	"plugin yearWitnessSet do: [ :each | 
		json := Dictionary new
			        at: 'context' put: each;
			        at: 'year' put: year;
			        yourself.
		plugin setTitleAndSettingsYearWitness: json ]"
]

{ #category : #initialization }
MyApp >> sendGetImage: webSocket [

	"sends highlightedImage for every YearSelector instance which has the same year as the current year displayed by YearWitness instances"

	arraySetImage do: [ :each | webSocket sendMessage: each ].

	"removes the previous elements stocked in order to not stack multiple times the same context with different values"
	arraySetImage removeAll: arraySetImage
]

{ #category : #initialization }
MyApp >> sendGetSettings: webSocket [

	"gets the settings for every YearSelector instance"

	arrayGetSettings do: [ :each | webSocket sendMessage: each ].

	"removes the previous elements stocked in order to not stack multiple times the same context with different values"
	arrayGetSettings removeAll: arrayGetSettings
]

{ #category : #initialization }
MyApp >> year [

	^ year
]

{ #category : #initialization }
MyApp >> year: anObject [

	"verify that anObject is equal to one of the numbers returned by the authorizedNumbers method, which are values transmitted from the Property Inspector."

	"also calls other methods to change every YearWitness instance's value as well as highlight YearSelector values with the chosen (valid) year value."

	| numbers numberInList |
	numbers := self authorizedNumbers.
	numberInList := 0.

	1 to: numbers size do: [ :i | 
		anObject = (numbers at: i) ifTrue: [ 
			year := anObject.
			numberInList := numberInList + 1 ] ].
	numberInList = 0 ifTrue: [ 
		self inform: 'Invalid number, see authorizedNumbers method' ].

	self modifyYearWitnessValue.
	self highlightYearSelectorSend
]
