"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part: I am used to launch the application which can interact with the Stream Deck and its Pharo graphical interface equivalent, which also explains my lack of methods.

For the Responsibility part: I send messages to myApp for data treatment and to pharostreamdeck for handling the GUI whenever a new plugin value is set.

For the Collaborators Part: My main collaborators are the MyApp and PharoStreamDeckGUI classes, which handle all the necessary operations (sending events to the Stream Deck, modifying the GUI's values...)

Public API and Key Messages
a year: 10.
a percent: 100

How to create instances:
a := AppLaunch new

    Instance Variables
	myApp:		<MyApp>
	pharostreamdeck:		<PharoStreamDeckGUI>
"
Class {
	#name : 'AppLaunch',
	#superclass : 'Object',
	#instVars : [
		'myApp',
		'pharostreamdeck'
	],
	#category : 'MyYearSelector',
	#package : 'MyYearSelector'
}

{ #category : 'initialization' }
AppLaunch >> initialize [
	"MyApp is a simple interface for YearSelector and PercentSelector which explains its lack of methods"

	"AppLaunch new is the correct way of initializing this application"

	pharostreamdeck := PharoStreamDeckGUI new.
	myApp := MyApp new.

	myApp initGUI: pharostreamdeck.
	pharostreamdeck myApp: myApp.

	super initialize
]

{ #category : 'initialization' }
AppLaunch >> myApp [

	^ myApp
]

{ #category : 'initialization' }
AppLaunch >> percent [

	^ myApp percent
]

{ #category : 'initialization' }
AppLaunch >> percent: aPercent [

	myApp percent: aPercent
]

{ #category : 'initialization' }
AppLaunch >> year [

	^ myApp year
]

{ #category : 'initialization' }
AppLaunch >> year: aYear [

	myApp year: aYear
]
