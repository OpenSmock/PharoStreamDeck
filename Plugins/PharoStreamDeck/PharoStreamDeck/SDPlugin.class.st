"
For the Class part: I am the class where most of the messages get sent. I redirect received messages to the appropriate method and action. I can also send data to the plugin when needed.

For the Responsibility part: I launch a server then treat the different events that are received from index.html (the JavaScript side of the plugin, which also sends some info about the Stream Deck at its launch). With the use of the initServer and `connected:receives:` method, each event is treated by the relevant Pharo class.

For the Collaborators Part: My main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin

How to create instances: I am launched in the `SDAppLaunch start`  method.
SDPlugin new.

**Instance variables:**
action: String, the uuid of the received message indicating which action is targeted. 
uuid: String, is it really useful ?
webSocket : ZnWebSocket, current websocket in use
serverStarted : Boolean, is the server started or not
receivedUUID: String received at register plugin.
"
Class {
	#name : 'SDPlugin',
	#superclass : 'Object',
	#instVars : [
		'action',
		'arrayGetSettings',
		'arraySetImage',
		'uuid',
		'typeObj',
		'webSocket',
		'serverStarted',
		'receivedUUID'
	],
	#classVars : [
		'arrayPlugin'
	],
	#category : 'PharoStreamDeck-Core',
	#package : 'PharoStreamDeck',
	#tag : 'Core'
}

{ #category : 'accessing' }
SDPlugin >> arrayPlugin [

	^ arrayPlugin
]

{ #category : 'accessing' }
SDPlugin >> arrayPlugin: anArrayPlugin [
	
	arrayPlugin := anArrayPlugin
]

{ #category : 'accessing' }
SDPlugin >> connected: aWebsocket receives: aMessage [

	| event jsonObject |
	"self inform: 'Received message: ' , message printString.""treats the data received accordingly, redirecting events to their respective method"
	jsonObject := STONJSON fromString: aMessage.
	event := jsonObject at: 'event'.
	action := jsonObject at: 'action'.
	Transcript
		show: aMessage;
		cr.
	"custom fields (i.e. ones that aren't required by an event as described in the SDK) are sent through the payload attribute of a JSON string"
	"string associated to inRegisterEvent in JavaScript"
	event = 'registerPlugin' ifTrue: [
		self registerPluginEvent: jsonObject ].

	"called when a key is pressed, is only a received event, doesn't need to be sent back to the plugin"
	event = 'keyUp' ifTrue: [ self keyUp: jsonObject ].

	event = 'didReceiveSettings' ifTrue: [ self receiveSettings: jsonObject ].

	event = 'willAppear' ifTrue: [ self willAppear: jsonObject  ]
]

{ #category : 'accessing' }
SDPlugin >> determineTypeObj [
	"actionSelectorWitness: changes the current plugin selected"

	((arrayPlugin actionSelectorWitness: 1) includes: action)
		ifTrue: [ typeObj := 'year' ]
		ifFalse: [
			((arrayPlugin actionSelectorWitness: 2) includes: action) ifTrue: [
				typeObj := 'percent' ] ]
]

{ #category : 'accessing' }
SDPlugin >> getGlobalSettings: jsonObj [
	"the getGlobalSettings event has no need to be sent to the plugin since the actions directly take place in Pharo"

	| varObj json pluginWitnessInstances |
	varObj := jsonObj at: typeObj.

	"creates a link between pluginWitnessSet and arrayJSONSetTitleAndSettingsWitness"
	pluginWitnessInstances := arrayPlugin pluginWitnessSet.
	pluginWitnessInstances do: [ :each |
		json := Dictionary new
			        at: 'context' put: each;
			        at: typeObj put: varObj;
			        yourself.
		self setTitleAndSettingsWitness: json ]
]

{ #category : 'accessing' }
SDPlugin >> getSettings: context [
	"used for highlightYearSelector: , so that the action value can be retrieved from a context. It's a way to know which Stream Deck has which action value attached to it."

	| settings jsonSettings |
	settings := Dictionary new
		            at: 'event' put: 'getSettings';
		            at: 'context' put: context;
		            yourself.

	jsonSettings := STONJSON toString: settings.
	^ jsonSettings
]

{ #category : 'accessing' }
SDPlugin >> highlightPluginSelectorReceive: jsonObj [
	"highlight Year/PercentSelector values with the chosen (valid value since checked in [variable of the class]: ) plugin value"

	"context is linked to an action value by the getSettings event which makes the plugin receive a didReceiveSettings event transmitting the action value, which is updated if keyUp: is triggered"

	"receives multiple times the same event, no need for a do: loop"

	| defaultImage highlightedImage context varObj |
	defaultImage := 'img/actionIcon.png'.
	highlightedImage := 'img/actionIconHighlighted.png'.
	arraySetImage := OrderedCollection new.
	
	action := jsonObj at: 'action'.
	self determineTypeObj.

	context := jsonObj at: 'context'.
	"values saved in the plugin field contained inside the payload field in setSettings: are obtained back with a settings field placed between them (see SDK documentation - https://docs.elgato.com/sdk/plugins/events-sent#setsettings)"
	varObj := (jsonObj at: 'payload' at: 'settings') at: typeObj.

	"sets the new blue background"
	varObj = arrayPlugin pluginValue ifTrue: [
		self setCurrentImage: context with: highlightedImage ].

	"resets the background to its original black"
	varObj = arrayPlugin pluginValue ifFalse: [
		self setCurrentImage: context with: defaultImage ].

	self sendImages
]

{ #category : 'initialization' }
SDPlugin >> initServer [
	"Creates a ZnManagingMultiThreadedServer HTTP port 8080 process, which needs to be terminated through the Process Browser if another server is to be launched"
	| server |
	server := ZnWebSocket
		startServerOn: 8080
		prefix: 'pharoBridge'
		do: [ :aWebSocket |
			[
			aWebSocket isConnected
				ifTrue: [
					serverStarted := true.
					webSocket :=aWebSocket .
					arrayPlugin do: [ :each | each webSocket: aWebSocket ].
					aWebSocket runWith: [ :message |
						self inform: 'Received message: ' , message printString.
						self connected: aWebSocket receives: message ] ]
				ifFalse: [ self error: 'The socket isn''t connected' ] ]
				on: ConnectionClosed , PrimitiveFailed
				do: [ "ignore close"
					serverStarted := nil.
					arrayPlugin removeAll ].
			self inform: 'The server is closed'.
			serverStarted := nil ].
]

{ #category : 'initialization' }
SDPlugin >> initialize [

	super initialize.

	uuid := 'com.thales.pharostreamdeck'.
	arrayPlugin := SDAppLaunch arrayPlugin.
	serverStarted ifNil: [ "arraySetImage := OrderedCollection new." "arrayGetSettings := OrderedCollection new."
		self initServer ]
]

{ #category : 'accessing' }
SDPlugin >> keyUp: jsonObj [
	|actualPlugin|
	
	actualPlugin := self whichAction: action.
	actualPlugin  pluginAction.
	^actualPlugin 
]

{ #category : 'accessing' }
SDPlugin >> keyUpBis: jsonObj [
	"sends multiple events (setSettings, getGlobalSettings so that the plugin receives a didReceiveGlobalSettings event)"

	| jsonSettings context arrayEvents jsonFormattedSettings highlightedImage jsonContext jsonWillAppear jsonFormattedWillAppear defaultImage varObj |
	"varObj being a year or a percent depending on the class it comes from""action being only affected to a value in willAppear: and keyUp: "
	action := jsonObj at: 'action'.
	Transcript show: action.
	context := jsonObj at: 'context'.

	defaultImage := 'img/actionIcon.png'.
	highlightedImage := 'img/actionIconHighlighted.png'.

	self determineTypeObj.

	"resets value to 0 if a Year/PercentWitness is pressed (for setTitle and setSettings)"
	"checks for every plugin if its type is Witness"
	(arrayPlugin witnessAction includes: action) ifTrue: [ varObj := 0 ].

	"values need to be saved for each plugin"
	(arrayPlugin selectorAction includes: action) ifTrue: [
		varObj := jsonObj at: 'payload' at: typeObj ].

	jsonWillAppear := Dictionary new
		                  at: 'action' put: action;
		                  at: 'context' put: context;
		                  at: 'payload' at: typeObj put: varObj;
		                  yourself.
	jsonFormattedWillAppear := (self willAppear: jsonWillAppear) at: 1.

	"used to reset keys highlighted by a command sent in the Pharo IDE using the MyApp class, these messages are sent before jsonFormattedSetHighlightedImage"
	arraySetImage := OrderedCollection new.

	arrayPlugin pluginWitnessSet do: [ :each |
		self setCurrentImage: each with: defaultImage ].

	arrayPlugin pluginSelectorSet do: [ :each |
		self setCurrentImage: each with: defaultImage ].

	self sendImages.

	"updates the plugin value of the relevant subclass of the PluginSharedActions class, which is needed to update the Witness instances"
	self sendValueHasChangedEvent: varObj.

	"returns the different events"
	arrayEvents := Array new: 2.
	"these attributes are all stringified JSON"
	arrayEvents at: 1 put: jsonFormattedSettings.
	arrayEvents at: 2 put: jsonFormattedWillAppear.

	^ arrayEvents
]

{ #category : 'accessing' }
SDPlugin >> keyUpEvent: jsonObject [
	"Used to be called by connect: receives: instead of keyUp"

	| arrayEvents jsonSettings jsonWillAppear |
	arrayEvents := self keyUpBis: jsonObject.

	jsonSettings := arrayEvents at: 1.
	jsonWillAppear := arrayEvents at: 2.

	webSocket sendMessage: jsonSettings.
	self sendUpdatePluginWitnessInstances
]

{ #category : 'accessing' }
SDPlugin >> modifyPluginWitnessValue [
	"this method is used to change every Year/PercentWitness instance's value"

	| json varObj |

	varObj := arrayPlugin pluginValue.
	json := Dictionary new
		        at: typeObj put: varObj;
		        yourself.
	self getGlobalSettings: json.
	"separated methods for sending all the events at the same time"
	self sendUpdatePluginWitnessInstances
]

{ #category : 'accessing' }
SDPlugin >> receiveSettings: aJSONObj [

Transcript show: aJSONObj 
]

{ #category : 'accessing' }
SDPlugin >> receivedUUID: aUUID [

	receivedUUID := aUUID
]

{ #category : 'accessing' }
SDPlugin >> registerPluginEvent: aJSONObject [


	self receivedUUID: (aJSONObject at: 'uuid') .

	Transcript show: (STONJSON toString: aJSONObject) .
	webSocket sendMessage: (STONJSON toString: aJSONObject)
]

{ #category : 'accessing' }
SDPlugin >> sendGetSettings [
	"gets the settings for every Year/PercentSelector instance by sending a setSettings event which adds a parameter to the settings of every instance"

	"done that way since the setSettings event sent in keyUp is necessary to keep track of each instance's value, also calls a didReceiveSettings event which updates every Year/PercentSelector having the same value as the one clicked"

	arrayGetSettings do: [ :each | webSocket sendMessage: each ].

	"removes the previous elements stocked in order to not stack multiple times the same context with different values"
	arrayGetSettings removeAll
]

{ #category : 'accessing' }
SDPlugin >> sendImages [
	"sends defaultImage or highlightedImage depending on the sender for every Year/PercentSelector instance"

	arraySetImage do: [ :each | webSocket sendMessage: each ].

	"removes the previous elements stocked in order to not stack multiple times the same context with different values"
	arraySetImage removeAll
]

{ #category : 'accessing' }
SDPlugin >> sendToPlugin: jsonObj [

	| newValue dictionaryNewValue context arrayEvents |
	action := jsonObj at: 'action'.
	newValue := jsonObj at: 'payload' at: 'setValue'.
	context := jsonObj at: 'context'.
	
	self determineTypeObj.

	dictionaryNewValue := Dictionary new
		                      at: 'context' put: context;
		                      at: typeObj put: newValue;
		                      yourself.

	arrayEvents := Array new: 2.
	arrayEvents at: 1 put: (self setSettings: dictionaryNewValue).
	arrayEvents at: 2 put: (self setTitlePI: dictionaryNewValue).

	^ arrayEvents
]

{ #category : 'accessing' }
SDPlugin >> sendToPluginEvent: jsonObject [

	| arrayEvents jsonSettings jsonTitle |
	arrayEvents := self sendToPlugin: jsonObject.

	jsonSettings := arrayEvents at: 1.
	jsonTitle := arrayEvents at: 2.

	webSocket sendMessage: jsonSettings.
	webSocket sendMessage: jsonTitle
]

{ #category : 'accessing' }
SDPlugin >> sendUpdatePluginWitnessInstances [
	"updates every Year/PercentWitness instance"

	arrayPlugin arrayJSONSetTitleAndSettingsPluginWitness do: [ :each |
		webSocket sendMessage: each ].

	"removes the previous elements stocked in order to not stack multiple times the same context with different values"
	arrayPlugin arrayJSONSetTitleAndSettingsPluginWitness removeAll
]

{ #category : 'accessing' }
SDPlugin >> sendValueHasChangedEvent: aNumber [
	"changes the plugin value, also updates the value shown on relevant Witness instances and highlight the relevant Selector instances"
	self pluginValueSuperclass: aNumber.
	
	self modifyPluginWitnessValue.
	self highlightPluginSelectorSend
]

{ #category : 'accessing' }
SDPlugin >> setCurrentImage: context with: img [

	| jsonDefaultImage jsonFormattedImage |
	jsonDefaultImage := Dictionary new
		                    at: 'context' put: context;
		                    at: 'image' put: img;
		                    yourself.

	jsonFormattedImage := self setImage: jsonDefaultImage.
	arraySetImage add: jsonFormattedImage
]

{ #category : 'accessing' }
SDPlugin >> setImage: jsonObj [

	| jsonFormattedObject json context image payload |
	context := jsonObj at: 'context'.
	image := jsonObj at: 'image'.

	payload := Dictionary new
		           at: 'image' put: image;
		           "value associated to DestinationEnum.HARDWARE_AND_SOFTWARE"
		           at: 'target'
		           put: 0;
		           yourself.

	jsonFormattedObject := Dictionary new
		                       at: 'event' put: 'setImage';
		                       at: 'context' put: context;
		                       "conversion to string to be displayed on the Stream Deck keys"
		                       at: 'payload'
		                       put: payload;
		                       yourself.
	json := STONJSON toString: jsonFormattedObject.

	^ json
]

{ #category : 'accessing' }
SDPlugin >> setImageEvent: jsonObject [

	| json |
	json := self setImage: jsonObject.
	webSocket sendMessage: json
]

{ #category : 'accessing' }
SDPlugin >> setSettings: jsonObj [
	"settings save data persistently, such as a value selected in the Property Inspector for a Year/PercentSelector"

	"function called from keyUp: and sendToPlugin: "

	| jsonFormattedObject context jsonSettings varObj |
	context := jsonObj at: 'context'.
	varObj := jsonObj at: typeObj.

	jsonFormattedObject := Dictionary new
		                       at: 'event' put: 'setSettings';
		                       at: 'context' put: context;
		                       at: 'payload' at: typeObj put: varObj;
		                       yourself.
	jsonSettings := STONJSON toString: jsonFormattedObject.

	^ jsonSettings
]

{ #category : 'accessing' }
SDPlugin >> setTitle: jsonObj [

	| jsonFormattedTitle context jsonTitle jsonSettings jsonFormattedSettings arrayEvents varObj |
	context := jsonObj at: 'context'.
	varObj := jsonObj at: typeObj.

	"can also receive it from the setTitle event sent when the Property Inspector value of a Year/PercentSelector is changed"
	jsonTitle := Dictionary new
		             at: 'event' put: 'setTitle';
		             at: 'context' put: context;
		             "string conversion to be displayed on the Stream Deck keys"
		             at: 'payload'
		             at: 'title'
		             put: varObj asString;
		             "value associated to DestinationEnum.HARDWARE_AND_SOFTWARE (see index.html)"
		             at: 'target'
		             put: 0;
		             yourself.
	jsonFormattedTitle := STONJSON toString: jsonTitle.

	"needs to update internal data so that there exists no disconnect between the display (through setTitle) and the data pertaining to each instance (through setSettings)"
	jsonSettings := Dictionary new
		                at: 'context' put: context;
		                at: typeObj put: varObj;
		                yourself.
	jsonFormattedSettings := self setSettings: jsonSettings.

	arrayEvents := Array new: 2.
	arrayEvents at: 1 put: jsonFormattedTitle.
	arrayEvents at: 2 put: jsonFormattedSettings.

	^ arrayEvents
]

{ #category : 'accessing' }
SDPlugin >> setTitleAndSettingsWitness: jsonObj [

	| context jsonTitle jsonFormattedTitle jsonSettings jsonFormattedSettings varObj |
	"this method is used to update every Year/PercentWitness instance through their context, which is the unique value that represents an instance"
	"it updates their title as well as their settings, so that willAppear: can load their new values when changing profiles"
	"used by getGlobalSettings: "
	"with context being each element sent to this method"
	"the plugin value is saved in the plugin field, located in the payload field"
	context := jsonObj at: 'context'.
	varObj := jsonObj at: typeObj.

	"loop so that every Year/PercentWitness instance is updated"
	jsonTitle := Dictionary new
		             at: 'event' put: 'setTitle';
		             at: 'context' put: context;
		             "cast to string to be displayed on the Stream Deck keys"
		             at: 'payload'
		             at: 'title'
		             put: varObj asString;
		             "value associated to DestinationEnum.HARDWARE_AND_SOFTWARE"
		             at: 'target'
		             put: 0;
		             yourself.
	jsonFormattedTitle := STONJSON toString: jsonTitle.

	jsonSettings := Dictionary new
		                at: 'event' put: 'setSettings';
		                at: 'context' put: context;
		                at: 'payload' at: typeObj put: varObj;
		                yourself.
	jsonFormattedSettings := STONJSON toString: jsonSettings.

	"is used to send all the setTitle and setSettings events that are necessary when more than one Year/PercentWitness instance is present on the current displayed Stream Deck profile"
	arrayPlugin arrayJSONSetTitleAndSettingsPluginWitness add:
		jsonFormattedTitle.
	arrayPlugin arrayJSONSetTitleAndSettingsPluginWitness add:
		jsonFormattedSettings
]

{ #category : 'accessing' }
SDPlugin >> setTitlePI: jsonObj [
	"for values received through the sendToPlugin event (value changed in the Property Inspector of a Year/PercentSelector instance)"

	"data persistence is limited to the launched server, as opposed to the JavaScript version of this plugn which has no constraint whatsoever"

	"No coordinates are used, favoring the use of the context field since coordinates are not received by using the sendToPlugin event"

	"receives it from the setTitle event sent when the Property Inspector value of a Year/PercentSelector is changed"

	| jsonFormattedObject context jsonTitle varObj |
	context := jsonObj at: 'context'.
	varObj := jsonObj at: typeObj.

	jsonFormattedObject := Dictionary new
		                       at: 'event' put: 'setTitle';
		                       at: 'context' put: context;
		                       "conversion to string to be displayed on the Stream Deck keys"
		                       at: 'payload'
		                       at: 'title'
		                       put: varObj asString;
		                       "value associated to DestinationEnum.HARDWARE_AND_SOFTWARE"
		                       at: 'target'
		                       put: 0;
		                       yourself.
	jsonTitle := STONJSON toString: jsonFormattedObject.

	^ jsonTitle
]

{ #category : 'accessing' }
SDPlugin >> typeObj: newTypeObj [

	typeObj := newTypeObj 
]

{ #category : 'accessing' }
SDPlugin >> uuid [

	^ uuid
]

{ #category : 'accessing' }
SDPlugin >> uuid: anObject [

	"used for the getGlobalSettings event for their context field. These settings are preserved between instances, notably for the plugin value for the subclasses of PluginSharedActions"

	uuid := anObject
]

{ #category : 'accessing' }
SDPlugin >> webSocket: aWebSocket [

	webSocket := aWebSocket
]

{ #category : 'accessing' }
SDPlugin >> whichAction: anAction [

	| arrayPlug |
	arrayPlug := SDAppLaunch arrayPlugin.
	arrayPlug do: [ :each |
		(each uuidAction = anAction) ifTrue: [
			
			^ each ] ].
	self error: 'There''s an issue with your plugin''s UUID'
]

{ #category : 'accessing' }
SDPlugin >> willAppear: jsonObj [

	self inform: jsonObj
]

{ #category : 'accessing' }
SDPlugin >> willAppearEvent: jsonObject [

	| arrayEvents jsonTitle jsonSettings |
	arrayEvents := self willAppear: jsonObject.

	"setTitle: calls setSettings: "
	jsonTitle := arrayEvents at: 1.
	jsonSettings := arrayEvents at: 2.
	"updates every Year/PercentWitness value if the current Stream Deck profile is changed (default value being 0)"
	webSocket sendMessage: jsonTitle.
	webSocket sendMessage: jsonSettings
]

{ #category : 'accessing' }
SDPlugin >> willAppearbis: jsonObj [

	| context varObj subdictionary arrayEvents payload |
	context := jsonObj at: 'context'.
	action := jsonObj at: 'action'.

	self determineTypeObj.
	varObj := 0.
	payload := jsonObj at: 'payload' ifAbsent: [ payload := 0 ].

	"initialize every value to be 0 so that nil isn't shown"
	payload = 0 ifFalse: [ varObj := payload at: typeObj ].

	"no punctuation apart from the dots that act as separators for the unique identifier"
	"checks for every plugin if its type is Witness"
	(arrayPlugin witnessAction includes: action) ifTrue: [ "context is globally unique across all actions, identifies an instance of an action on the Stream Deck but changes when the Stream Deck application is relaunched, also changes when actions are duplicated or moved"
		arrayPlugin pluginWitnessSet add: context ].

	"checks for every plugin if its type is Selector"
	(arrayPlugin selectorAction includes: action) ifTrue: [
		arrayPlugin pluginSelectorSet add: context ].

	subdictionary := Dictionary new
		                 at: 'context' put: context;
		                 at: typeObj put: varObj;
		                 yourself.

	arrayEvents := self setTitle: subdictionary.
	^ arrayEvents
]

{ #category : 'as yet unclassified' }
SDPlugin >> willDisappear [
	"removes all Witness instances through their context as well as all setTitle events for Witness instances for the relevant Pharo class when the user changes to a profile that doesn't contain an instance of an action from the PharoStreamDeck plugin"

	SDAppLaunch arrayPlugin removeAll.
	"arrayPlugin pluginSelectorSet removeAll.
	arrayPlugin arrayJSONSetTitleAndSettingsPluginWitness removeAll"
]
