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
arrayPlugin is used for methods relative to plugin values in the MyApp class, to keep track of all the plugins so that a YearSelector and a PercentSelector can be launched and modified at the same time""
"
Class {
	#name : #MyApp,
	#superclass : #Object,
	#instVars : [
		'plugin',
		'pluginSharedActions',
		'arrayPlugin',
		'launchedServer',
		'serverState'
	],
	#category : #MyYearSelector
}

{ #category : #initialization }
MyApp >> arrayPluginAdd: pluginSelector [

	| arrayPluginContents |
	arrayPluginContents := arrayPlugin arrayPluginContents.
	(arrayPluginContents includes: pluginSelector) ifFalse: [ "each plugin is aware of the existence of the other plugins, so that the arrayPluginValue: with: method in PluginSharedActions can determine which plugin to reference to update values" "ifFalse: so that a plugin can't be referenced multiple times by every plugin" "arrayPlugin do: [ :each |
		each arrayPlugin ifNotNil: [
			(each arrayPlugin includes: aPlugin) ifFalse: [
				each arrayPlugin add: aPlugin ] ] ]"
		arrayPluginContents add: pluginSelector ]
]

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
MyApp >> initArrayPlugins [
	"each plugin is aware of the existence of the other plugins, so that the arrayPluginValue: with: method in PluginSharedActions can determine which plugin to reference to update their respective Witness instances' value"

	| arrayPluginContents currentPlugin |
	arrayPluginContents := arrayPlugin arrayPluginContents.
	"ifFalse: so that a plugin can't be referenced multiple times by every plugin"
	"arrayPlugin do: [ :each |
		each arrayPlugin ifNotNil: [
			(each arrayPlugin includes: aPlugin) ifFalse: [
				each arrayPlugin add: aPlugin ] ] ]"
	
	"two loops here, YearSelector knows itself and the PercentSelector, PercentSelector knows itself and the YearSelector, would be the same for three and more plugins launched"
	arrayPluginContents do: [ :each |
		arrayPluginContents do: [ :each2 | 
			currentPlugin := each arrayPluginGet.
			currentPlugin add: each2 ] ]
]

{ #category : #initialization }
MyApp >> initPlugin: aPlugin [

	| pluginSelector |
	pluginSelector := aPlugin new.
	self launchServerPlugin: pluginSelector.
	arrayPlugin arrayPluginContents add: pluginSelector
]

{ #category : #initialization }
MyApp >> initPlugins [
	"aggregation link between MyApp and YearSelector and MyApp and PercentSelector, YearSelector and PercentSelector can still be launched alone, see GitHub diagram)"

	arrayPlugin := ArrayPlugin new.
	
	launchedServer := LaunchedServer new.
	serverState := launchedServer launchedServerState.
	
	self initPlugin: YearSelector.
	self initPlugin: PercentSelector.
	
	self initArrayPlugins.
	self initServer

	"Subscribe to plugin events"
	
]

{ #category : #initialization }
MyApp >> initServer [
	
	| pluginSelector arrayPluginContents |
	arrayPluginContents := arrayPlugin arrayPluginContents.
	pluginSelector := arrayPluginContents at: 1.
	pluginSelector initServer
]

{ #category : #initialization }
MyApp >> initialize [
	"MyApp is a simple interface for YearSelector and PercentSelector which explains its lack of methods"

	self initPlugins
]

{ #category : #initialization }
MyApp >> launchServerPlugin: pluginSelector [

	pluginSelector launchedServer: launchedServer.
	pluginSelector launchedServerState: serverState.
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

{ #category : #'as yet unclassified' }
MyApp >> percent [
	
	| arrayPluginContents |
	arrayPluginContents := arrayPlugin arrayPluginContents.
	plugin := arrayPluginContents at: 2.
	^ plugin percent
]

{ #category : #'as yet unclassified' }
MyApp >> percent: aPercent [
	
	| arrayPluginContents |
	arrayPluginContents := arrayPlugin arrayPluginContents.
	plugin := arrayPluginContents at: 2.
	plugin sendValueHasChangedEvent: aPercent
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
	
	| arrayPluginContents |
	arrayPluginContents := arrayPlugin arrayPluginContents.
	plugin := arrayPluginContents at: 1.
	^ plugin year
]

{ #category : #initialization }
MyApp >> year: aYear [
	
	| arrayPluginContents |
	arrayPluginContents := arrayPlugin arrayPluginContents.
	plugin := arrayPluginContents at: 1.
	plugin sendValueHasChangedEvent: aYear
]

{ #category : #initialization }
MyApp >> yearUpdate: anObject [
	"since the year: method calls other functions, is only used in keyUp; "
	
	year := anObject
]
