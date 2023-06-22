"
For the Class part: I represent a container for the instances of the PluginSharedActions class, which is to say that launching an instance of MyApp launches an instance of every subclass of PluginSharedActions.

For the Responsibility part: I contain the subclasses of PluginSharedActions by using methods that can directly modify their state, such as their pluginValue selected.

For the Collaborators Part: My main collaborator is PluginSharedActions and its subclasses, which interact with index.html as well as the Stream Deck.

Public API and Key Messages
How to create instances:
m := MyApp new

How to interact with this class:
m year: 10 (checks if the value is possible to affect through numberInAuthorizedNumbers:  and authorizedNumbers methods)
m: percent: 50

Instance variables:
plugin knows which plugin is used
arrayGetSettings is used to keep track of all the getSettings events that need to be sent to know which Selector instances to highlight when the pluginValueSuperclass: method of PluginSharedActions is called
arraySetImage is used to send to the plugin multiple times the same image (highlighted blue background) for every Selector instance that matches the pluginValue value sent through the pluginValueSuperclass: method of PluginSharedActions
arrayPlugin is used for methods relative to plugin values in the MyApp class, to keep track of all the plugins so that a YearSelector and a PercentSelector can be launched and modified at the same time
launchedServer and serverState are used to only launch one ZnManagingMultiThreadedSerevr HTTP server, no matter the number of plugins (instances of PluginSharedActions)
"
Class {
	#name : #MyApp,
	#superclass : #Object,
	#instVars : [
		'arrayPlugin',
		'launchedServer',
		'pharostreamdeck'
	],
	#category : #MyYearSelector
}

{ #category : #'as yet unclassified' }
MyApp >> arrayPlugin [

	^ arrayPlugin
]

{ #category : #'as yet unclassified' }
MyApp >> chooseCurrentPlugin: index [

	| arrayPluginContents plugin |
	arrayPluginContents := arrayPlugin arrayPluginContents.
	plugin := arrayPluginContents at: index.
	"also updates the currently selected plugin for arrayPlugin"
	arrayPlugin plugin: plugin.
	"DO NOT delete this plugin return, trying to access arrayPlugin plugin in year; and percent: makes everything crashes"
	^ plugin

]

{ #category : #initialization }
MyApp >> initArrayPlugins [
	"each plugin is aware of the existence of the other plugins, so that the numberInAuthorizedNumbers: method in PluginSharedActions can determine which plugin to reference to update their respective Witness instances' value"

	| arrayPluginContents |
	arrayPluginContents := arrayPlugin arrayPluginContents.
	arrayPluginContents do: [ :each | each arrayPlugin: arrayPlugin ]
]

{ #category : #initialization }
MyApp >> initGUI [

	| arrayPluginContents |
	pharostreamdeck := PharoStreamDeckGUI new.
	pharostreamdeck open.

	"every plugin is made aware of the existence of the GUI"
	arrayPluginContents := arrayPlugin arrayPluginContents.
	arrayPluginContents do: [ :each |
		each pharoStreamDeckGUI: pharostreamdeck ]
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
	
	self initPlugin: YearSelector.
	self initPlugin: PercentSelector.
	
	self initArrayPlugins.
	self initServer.
	
	self initGUI.
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
]

{ #category : #'as yet unclassified' }
MyApp >> percent [
	
	| plugin |
	plugin := self chooseCurrentPlugin: 2.
	^ plugin pluginValue
]

{ #category : #'as yet unclassified' }
MyApp >> percent: aPercent [
	
	| plugin |
	plugin := self chooseCurrentPlugin: 2.
	plugin typeObj: 'percent'.
	plugin sendValueHasChangedEvent: aPercent.
	pharostreamdeck updateWitnessButtons.
]

{ #category : #initialization }
MyApp >> year [
	
	| plugin |
	plugin := self chooseCurrentPlugin: 1.
	^ plugin pluginValue
]

{ #category : #initialization }
MyApp >> year: aYear [
	
	| plugin |
	plugin := self chooseCurrentPlugin: 1.
	plugin typeObj: 'year'.
	plugin sendValueHasChangedEvent: aYear.
	pharostreamdeck updateWitnessButtons.
]
