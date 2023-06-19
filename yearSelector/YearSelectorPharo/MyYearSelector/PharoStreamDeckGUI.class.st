"
For the Class part:  I'm a Graphical User Interface for the MyApp class, replicating what is possible on the Stream Deck.

For the Responsibility part: I can select a year and a percent value, highlight the pressed button and show what is currently the value taken by MyApp. I can communicate with the Stream Deck if it's launched, but my UI doesn't need it in order to communicated with the Pharo classes.

For the Collaborators Part: My main collaborator is the MyApp class, since it launches an instance of every plugin.

    Instance Variables
	buttonFifteen:		<Object>
	buttonFifty:		<Object>
	buttonFive:		<Object>
	buttonHundred:		<Object>
	buttonHundredFifty:		<Object>
	buttonList:		<Object>
	buttonPercent:		<Object>
	buttonTen:		<Object>
	buttonTwenty:		<Object>
	buttonTwoHundred:		<Object>
	buttonWitnessPercent:		<Object>
	buttonWitnessYear:		<Object>
	buttonYear:		<Object>
	buttonZero:		<Object>
	emptyButton:		<Object>
	myApp:		<Object>
"
Class {
	#name : #PharoStreamDeckGUI,
	#superclass : #SpDemoButtonsPresenter,
	#instVars : [
		'buttonZero',
		'buttonFive',
		'buttonTen',
		'buttonFifteen',
		'buttonTwenty',
		'buttonFifty',
		'buttonHundred',
		'buttonHundredFifty',
		'buttonTwoHundred',
		'myApp',
		'buttonList',
		'buttonYear',
		'buttonPercent',
		'emptyButton',
		'buttonWitnessYear',
		'buttonWitnessPercent'
	],
	#category : #MyYearSelector
}

{ #category : #initialization }
PharoStreamDeckGUI >> connectPresenters [ 
	"example inspired from the code available in the Help tab -> Spec2 demo -> Buttons -> Code tab"
	"to instantiate this GUI, use PharoStreamDeckGUI new open"
	"the actions are linked here to the buttons"
	buttonZero action: [ myApp year: 0 ].
	buttonFive action: [ myApp year: 5 ].
	buttonTen action: [ myApp year: 10 ].
	buttonFifteen action: [ myApp year: 15 ].
	buttonTwenty action: [ myApp year: 20 ].
	
	buttonFifty action: [ myApp percent: 50 ].
	buttonHundred action: [ myApp percent: 100 ].
	buttonHundredFifty action: [ myApp percent: 150 ].
	buttonTwoHundred action: [ myApp percent: 200 ]
]

{ #category : #initialization }
PharoStreamDeckGUI >> defaultLayout [

	^ SpGridLayout build: [ :builder |
		builder 
			beColumnHomogeneous;
			beRowHomogeneous;
			borderWidth: 0;
			add: buttonYear;
			add: buttonWitnessYear;
			add: emptyButton;
			add: buttonZero;
			add: buttonFive;
			add: buttonTen;
			add: buttonFifteen;
			add: buttonTwenty;
			nextRow; 
			add: buttonPercent;
			add: buttonWitnessPercent;
			add: emptyButton;
			add: buttonFifty;
			add: buttonHundred;
			add: buttonHundredFifty;
			add: buttonTwoHundred ]
]

{ #category : #initialization }
PharoStreamDeckGUI >> extent [
	"size of the window"
	^ 200@100
]

{ #category : #initialization }
PharoStreamDeckGUI >> initializePresenters [

	myApp := MyApp new.

	buttonZero := self newButton label: '0'.
	buttonFive := self newButton label: '5'.
	buttonTen := self newButton label: '10'.
	buttonFifteen := self newButton label: '15'.
	buttonTwenty := self newButton label: '20'.

	buttonFifty := self newButton label: '50'.
	buttonHundred := self newButton label: '100'.
	buttonHundredFifty := self newButton label: '150'.
	buttonTwoHundred := self newButton label: '200'.
	
	buttonYear := self newButton
		label: 'Year';
		disable;
		yourself.
	buttonPercent := self newButton
		label: 'Percent';
		disable;
		yourself.
	emptyButton := self newButton
		label: '';
		disable;
		yourself.
	buttonWitnessYear := self newButton label: (myApp year) asString.
	buttonWitnessPercent := self newButton label: (myApp percent) asString.
			
	buttonList := OrderedCollection new.
	buttonList
		add: buttonZero;
		add: buttonFive;
		add: buttonTen;
		add: buttonFifteen;
		add: buttonTwenty;
		add: buttonFifty;
		add: buttonHundred;
		add: buttonHundredFifty;
		add: buttonTwoHundred.

	buttonList do: [ :each | self focusOrder add: each ]
]

{ #category : #initialization }
PharoStreamDeckGUI >> selectedButton: button [

	"resets the background of every button"
	buttonList do: [ :each | each selected: false ].
	
	buttonWitnessYear label: 
	
	"highlights the button pressed"
	button selected: true
]

{ #category : #initialization }
PharoStreamDeckGUI >> title [

	^ 'PharoStreamDeck'
]
