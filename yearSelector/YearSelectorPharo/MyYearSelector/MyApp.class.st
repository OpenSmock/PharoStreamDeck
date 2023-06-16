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
		'serverState',
		'arraySetImage',
		'arrayGetSettings'
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
