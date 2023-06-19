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
		'myApp'
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
			add: buttonZero;
			add: buttonFive;
			add: buttonTen;
			add: buttonFifteen;
			add: buttonTwenty;
			nextRow; 
			add: buttonFifty;
			add: buttonHundred;
			add: buttonHundredFifty;
			add: buttonTwoHundred ]
]

{ #category : #initialization }
PharoStreamDeckGUI >> extent [
	"size of the window"
	^ 400@100
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

	self focusOrder
		add: buttonZero;
		add: buttonFive;
		add: buttonTen;
		add: buttonFifteen;
		add: buttonTwenty;
		
		add: buttonFifty;
		add: buttonHundred;
		add: buttonHundredFifty;
		add: buttonTwoHundred
]

{ #category : #initialization }
PharoStreamDeckGUI >> title [

	^ 'PharoStreamDeck'
]
