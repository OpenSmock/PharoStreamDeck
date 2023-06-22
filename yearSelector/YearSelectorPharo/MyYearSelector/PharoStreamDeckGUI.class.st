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
		'buttonList',
		'buttonYear',
		'buttonPercent',
		'emptyButton',
		'buttonWitnessYear',
		'buttonWitnessPercent',
		'buttonYearList',
		'buttonPercentList',
		'year',
		'percent'
	],
	#category : #MyYearSelector
}

{ #category : #initialization }
PharoStreamDeckGUI >> connectPresenters [
	"example inspired from the code available in the Help tab -> Spec2 demo -> Buttons -> Code tab"

	"to instantiate this GUI, use PharoStreamDeckGUI new open"

	"the actions are linked here to the buttons"

	buttonZero action: [ self selectedButton: buttonZero with: buttonZero label ].
	buttonFive action: [ self selectedButton: buttonFive with: buttonFive label ].
	buttonTen action: [ self selectedButton: buttonTen with: buttonTen label ].
	buttonFifteen action: [ self selectedButton: buttonFifteen with: buttonFifteen label ].
	buttonTwenty action: [ self selectedButton: buttonTwenty with: buttonTwenty label ].

	buttonFifty action: [ self selectedButton: buttonFifty with: buttonFifty label ].
	buttonHundred action: [ self selectedButton: buttonHundred with: buttonHundred label ].
	buttonHundredFifty action: [ self selectedButton: buttonHundredFifty with: buttonHundredFifty label ].
	buttonTwoHundred action: [ self selectedButton: buttonTwoHundred with: buttonTwoHundred label ].
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
	^ 400@100
]

{ #category : #initialization }
PharoStreamDeckGUI >> initializePresenters [

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
	
	year := 0.
	percent := 50.
	buttonWitnessYear := self newButton label: year asString.
	buttonWitnessPercent := self newButton label: percent asString.

	buttonList := OrderedCollection new.
	buttonYearList := OrderedCollection new.
	buttonPercentList := OrderedCollection new.
	
	buttonYearList
		add: buttonZero;
		add: buttonFive;
		add: buttonTen;
		add: buttonFifteen;
		add: buttonTwenty.
	buttonPercentList
		add: buttonFifty;
		add: buttonHundred;
		add: buttonHundredFifty;
		add: buttonTwoHundred.
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
PharoStreamDeckGUI >> percent: aPercent [

	percent := aPercent.
	self updateWitnessButtons.
]

{ #category : #initialization }
PharoStreamDeckGUI >> selectedButton: button with: pluginValue [

	"updates the value depending on the button affiliated to a plugin"
	(buttonYearList includes: button) ifTrue: [ 
		self year: pluginValue ].
	(buttonPercentList includes: button) ifTrue: [ 
		self percent: pluginValue].
	
	"updates the relevant Witness instance through MyApp's plugin value"
	self updateWitnessButtons.

	"resets the background of every button"
	buttonList do: [ :each | each state: false ].
	"highlights the pressed button"
	button state: true.
]

{ #category : #initialization }
PharoStreamDeckGUI >> title [

	^ 'PharoStreamDeck'
]

{ #category : #initialization }
PharoStreamDeckGUI >> updateWitnessButtons [
	"updates the relevant Witness instance through MyApp's plugin value"

	buttonWitnessYear label: year asString.
	buttonWitnessPercent label: percent asString
]

{ #category : #initialization }
PharoStreamDeckGUI >> year: aYear [
	
	year := aYear.
	self updateWitnessButtons.
]
