"
Used to launch the application which can interact with the Stream Deck and its Pharo graphical interface equivalent.
For the Responsibility part: I send messages to myApp for data treatment and to pharostreamdeck for handling the GUI whenever a new plugin value is set.
Send messages to myApp for data treatment and to pharostreamdeck for handling the GUI whenever a new plugin value is set.

Create instances:
'StreamDeckApp new'

Instance Variables
- myApp:				<MyApp>
- pharostreamdeck:		<PharoStreamDeckGUI>
"
Class {
	#name : 'SDApp',
	#superclass : 'Object',
	#instVars : [
		'view',
		'pluginList',
		'server'
	],
	#category : 'PharoStreamDeck-App',
	#package : 'PharoStreamDeck',
	#tag : 'App'
}

{ #category : 'script' }
SDApp class >> showWindow [
	"Open a simulation window of the application"
	
	<script>
	
	| app |
	
	app := self new.
	app addNewPlugin: YearSelector new.
	app addNewPlugin: SDPercentSelector new.
	
	^ app

]

{ #category : 'operation' }
SDApp >> addNewPlugin: aSDPlugin [

	aSDPlugin launchedServer: server.
	pluginList add: aSDPlugin .

]

{ #category : 'as yet unclassified' }
SDApp >> initGUI [
	
	view open.

	"every plugin is made aware of the existence of the GUI"
	pluginList do: [ :each |
		each pharoStreamDeckGUI: view ].	

]

{ #category : 'initialization' }
SDApp >> initialize [

	self view: PharoStreamDeckGUI new.
	pluginList := OrderedCollection new.
	server := LaunchedServer new.
	
	self initGUI.	
	view myApp: self.
	
	super initialize
]

{ #category : 'accessing' }
SDApp >> pluginList [

	^ pluginList
]

{ #category : 'accessing' }
SDApp >> pluginList: aListOfSDPlugin [

	pluginList := aListOfSDPlugin asOrderedCollection 
]

{ #category : 'accessing' }
SDApp >> server [

	^ server
]

{ #category : 'accessing' }
SDApp >> server: aSDServer [

	server := aSDServer
]

{ #category : 'accessing' }
SDApp >> view [

	^ view
]

{ #category : 'accessing' }
SDApp >> view: aSDGUI [

	view := aSDGUI
]
