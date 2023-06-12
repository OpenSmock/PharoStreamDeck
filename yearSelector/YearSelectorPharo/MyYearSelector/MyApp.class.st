"
For the Class part:  I represent a container for the YearSelector class, which is to say that launching an instance of MyApp launches an instance of YearSelector.

For the Responsibility part: I contain the YearSelector class by using methods that can directly modify its state, such as the year selected. It's a way to influence multiple YearSelector instances selected at once, as well as the value shown on YearWitness instances.

For the Collaborators Part: My main collaborator is the YearSelector class, which interacts with index.html as well as the Stream Deck.

Public API and Key Messages
How to create instances:
m := MyApp new

How to interact with this class:
m year: 10 (checks if the value is possible to affect through the authorizedNumbers method)

Instance variables:
plugin knows which plugin is used (namely YearSelector)
year is used to memoriez the year value which is shown on YearWitness instances
arrayGetSettings is used to keep track of all the getSettings events that need to be sent to know which YearSelector instances to highlight when the year: method is called
arraySetImage is used to send to the plugin multiple times the same image (highlighted blue background) for every YearSelector instance that matches the year value sent through the year: method
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
	plugin getGlobalSettings: json.
	plugin sendUpdateYearWitnesses: plugin WebSocket
]

{ #category : #initialization }
MyApp >> sendGetImage: webSocket [

	"sends highlightedImage for every YearSelector instance which has the same year as the current year displayed by YearWitness instances"

	arraySetImage do: [ :each | webSocket sendMessage: each ].

	"removes the previous elements stocked in order to not stack multiple times the same context with different values"
	arraySetImage removeAll
]

{ #category : #initialization }
MyApp >> sendGetSettings: webSocket [

	"gets the settings for every YearSelector instance by sending a setSettings event which adds a paremeter to the settings of every instance, deleting it afterhand"
	"done that way since the setSettings event sent in keyUp is necessary to keep track of each instance's value, also calls a didReceiveSettings event which updated every YearSelector having the same value as the one clicked"

	arrayGetSettings do: [ :each | webSocket sendMessage: each ].

	"removes the previous elements stocked in order to not stack multiple times the same context with different values"
	arrayGetSettings removeAll
]

{ #category : #initialization }
MyApp >> year [

	^ year
]

{ #category : #initialization }
MyApp >> year: aNumber [
	"verify that aNumber is equal to one of the numbers returned by the authorizedNumbers method, which are values transmitted from the Property Inspector."

	"also calls other methods to change every YearWitness instance's value as well as highlight YearSelector values with the chosen (valid) year value."

	| numbers |
	year = aNumber ifTrue: [ ^ self ].

	numbers := self authorizedNumbers.
	numbers
		detect: [ :e | e = aNumber ]
		ifFound: [ :e | year := e ]
		ifNone: [
			self inform: 'Invalid number, see authorizedNumbers method'.
			^ self ].

	self modifyYearWitnessValue.
	"since the year: method is only called with MyApp, is used to update all the yearWitness instances"
	plugin throughKeyUp: false.
	self highlightYearSelectorSend
]

{ #category : #initialization }
MyApp >> yearUpdate: anObject [
	"since the year: method calls other functions, is only used in keyUp; "
	
	year := anObject
]
