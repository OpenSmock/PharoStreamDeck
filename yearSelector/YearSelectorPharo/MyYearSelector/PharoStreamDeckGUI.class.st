"
For the Class part:  I'm a Graphical User Interface for the MyApp class, replicating what is shown on the Stream Deck.

For the Responsibility part: I can select a year and a percent value, highlight the pressed button and show what arethe current values taken by the MyApp class for year and percent. I can communicate with the Stream Deck if it's launched, but my UI doesn't need it in order to communicate with the Pharo classes.

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
		'percent',
		'myApp',
		'buttonHundredTwenty'
	],
	#category : #MyYearSelector
}

{ #category : #initialization }
PharoStreamDeckGUI >> connectPresenters [
	"example inspired from the code available in the Help tab -> Spec2 demo -> Buttons -> Code tab"

	"this method links buttons to their actions"

	buttonZero action: [
		self selectedButton: buttonZero with: buttonZero label ].
	buttonFive action: [
		self selectedButton: buttonFive with: buttonFive label ].
	buttonTen action: [
		self selectedButton: buttonTen with: buttonTen label ].
	buttonFifteen action: [
		self selectedButton: buttonFifteen with: buttonFifteen label ].
	buttonTwenty action: [
		self selectedButton: buttonTwenty with: buttonTwenty label ].

	buttonFifty action: [
		self selectedButton: buttonFifty with: buttonFifty label ].
	buttonHundred action: [
		self selectedButton: buttonHundred with: buttonHundred label ].
	buttonHundredTwenty action: [
		self
			selectedButton: buttonHundredTwenty
			with: buttonHundredTwenty label ].
	buttonTwoHundred action: [ 
		self selectedButton: buttonTwoHundred with: buttonTwoHundred label ]
	
	"this syntax doesn't work"
	"buttonList do: [ :each | self selectedButton: each with: each label ]"
]

{ #category : #initialization }
PharoStreamDeckGUI >> defaultLayout [

	^ SpBoxLayout newVertical
		  spacing: 4;
		  add: (SpBoxLayout newHorizontal
				   spacing: 4;
				   add: buttonYear width: 100;
				   add: buttonWitnessYear;
				   add: emptyButton;
				   add: buttonZero;
				   add: buttonFive ;
				   add: buttonTen;
				   add: buttonFifteen ;
				   add: buttonTwenty;
				   yourself);
		  add: (SpBoxLayout newHorizontal
				   spacing: 4;
				   add: buttonPercent width: 100;
				   add: buttonWitnessPercent;
				   add: emptyButton ;
				add: SpNullPresenter new;
				   add: buttonFifty ;
				   add: buttonHundred ;
				   add: buttonHundredTwenty ;
				   add: buttonTwoHundred;
				   yourself);
		  yourself
]

{ #category : #initialization }
PharoStreamDeckGUI >> highlightPressedButton [
	"resets the background of every button"

	buttonList do: [ :each | each state: false ].

	"highlights the pressed button with the value corresponding to the one sent"
	buttonList do: [ :each |
		year asString = each label ifTrue: [ each state: true ].
		percent asString = each label ifTrue: [ each state: true ] ]
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
	buttonHundredTwenty := self newButton label: '120'.
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
		add: buttonHundredTwenty;
		add: buttonTwoHundred.
		
	buttonYearList do: [ :each | buttonList add: each ].
	buttonPercentList do: [ :each | buttonList add: each ].

	buttonList do: [ :each | self focusOrder add: each ]
]

{ #category : #initialization }
PharoStreamDeckGUI >> myApp: aMyApp [

	myApp := aMyApp
]

{ #category : #initialization }
PharoStreamDeckGUI >> percent: aPercent [

	percent := aPercent.
	myApp percent: aPercent.
	
	"can't put these methods in selectedButton: with:, doesn't work"
	self updateWitnessButtons.
	self highlightPressedButton.
]

{ #category : #initialization }
PharoStreamDeckGUI >> selectedButton: button with: pluginValue [
	"updates the value depending on the button affiliated to a plugin"

	(buttonYearList includes: button) ifTrue: [ self year: pluginValue ].
	(buttonPercentList includes: button) ifTrue: [
		self percent: pluginValue ]
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
	myApp year: aYear.

	"can't put these methods in selectedButton: with: , doesn't work"
	self updateWitnessButtons.
	self highlightPressedButton
]
