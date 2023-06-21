"
For the Class part:  I am an abstract class which possess the shared actions between YearSelector and PercentSelector

For the Responsibility part: I launch a server then treat the different events that are received from index.html (the JavaScript side of the plugin,which also sends some info about the Stream Deck at its launch). With the use of the initServer method, each event is treated by the Pharo class that is concerned

For the Collaborators Part: my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on their grids through the PharoStreamDeck plugin

How to create instances:
Since I'm an abstract class, I'm not supposed to be launched.
However, YearSelector and PercentSelector are concrete implementations of myself and they themselves can be launched through YearSelector new and PercentSelector new.

Instance variables:
uuid is the unique value identifying the plugin (inPluginUUID in JavaScript code). It's sent via the registration procedure, recuperated from the connectElgatoStreamDeckSocket() function (https://developer.elgato.com/documentation/stream-deck/sdk/registration-procedure/#compiled-plugin-registration) and is used in the setGlobalSettings: method for its context field, since globalSettings events require more than a context value to share a setting between instances of plugins (see SDK documentation - events sent https://developer.elgato.com/documentation/stream-deck/sdk/events-sent/#setglobalsettings)
WebSocket memorizes the WebSocket that is launched in initServer to send messages in other functions, notably with the arrays' content
plugin memorizes the current selected plugin, so that it can highlight the relevant Selector instances and update the values of the relevannt Witness instances
arraySetImage and arrayGetSettings are used to send in bulk multiple events of the type of their names
action memorizes the action field that is sent when the initial message is received, so that it can easily differentaite between Year and Percent instances (corresponds to the UUID field in manifest.json for every action)
launchedServerState and launchedServer are the instance variables of the LaunchedServer class, to know whether or not one is launched
arrayPlugin is the instance variable of the ArrayPlugin class, to know which plugins are launched
"
Class {
	#name : #PluginSharedActions,
	#superclass : #Object,
	#instVars : [
		'WebSocket',
		'action',
		'arrayGetSettings',
		'arrayPlugin',
		'arraySetImage',
		'launchedServer',
		'uuid',
		'typeObj'
	],
	#category : #MyYearSelector
}

{ #category : #accessing }
PluginSharedActions >> WebSocket: aWebSocket [

	WebSocket := aWebSocket
]

{ #category : #accessing }
PluginSharedActions >> arrayPlugin [

	^ arrayPlugin
]

{ #category : #accessing }
PluginSharedActions >> arrayPlugin: anArrayPlugin [

	arrayPlugin := anArrayPlugin
]

{ #category : #accessing }
PluginSharedActions >> determineTypeObj [

	((arrayPlugin actionSelectorWitness: 1) includes: action) ifTrue: [
		typeObj := 'year' ].
	((arrayPlugin actionSelectorWitness: 1) includes: action) ifFalse: [
		((arrayPlugin actionSelectorWitness: 2) includes: action) ifTrue: [
			typeObj := 'percent' ] ]
]

{ #category : #accessing }
PluginSharedActions >> getGlobalSettings: jsonObj [
	"not automatically called when setGlobalSettings is called, which is why this method is needed"

	"here, the getGlobalSettings event has no need to be sent to the plugin since the actions directly take place in Pharo"

	| varObj json pluginWitnessInstances |
	varObj := jsonObj at: typeObj.

	"creates a link between yearWitnessSet and arrayJsonSetTitleAndSettingsYearWitness"
	pluginWitnessInstances := arrayPlugin pluginWitnessSet.
	pluginWitnessInstances do: [ :each |
		json := Dictionary new
			        at: 'context' put: each;
			        at: typeObj put: varObj;
			        yourself.
		self setTitleAndSettingsYearWitness: json ]
]

{ #category : #accessing }
PluginSharedActions >> getSettings: context [
	"used for highlightYearSelector: , so that the action value can be retrieved from a context. It's a way to know which Stream Deck has which action value attached to it."

	| settings jsonSettings |
	settings := Dictionary new
		            at: 'event' put: 'getSettings';
		            at: 'context' put: context;
		            yourself.

	jsonSettings := STONJSON toString: settings.
	^ jsonSettings
]

{ #category : #accessing }
PluginSharedActions >> highlightPluginSelectorReceive: jsonObj [
	"highlight Year/PercentSelector values with the chosen (valid value since checked in [variable of the class]: ) plugin value"

	"context is linked to an action value by the getSettings event which makes the plugin receive a didReceiveSettings event transmitting the action value, which is updated if keyUp: is triggered"

	"receives multiple times the same event, no need for a do: loop"

	| defaultImage highlightedImage context varObj |
	defaultImage := 'img/actionIcon.png'.
	highlightedImage := 'img/actionIconHighlighted.png'.
	arraySetImage := OrderedCollection new.

	context := jsonObj at: 'context'.
	"values saved in the plugin field contained inside the payload field in setSettings: are obtained back with a settings field placed between them"
	varObj := (jsonObj at: 'payload' at: 'settings') at: typeObj.

	"sets the new blue background"
	varObj = arrayPlugin pluginValue ifTrue: [
		self setCurrentImages: context with: highlightedImage ].

	"resets the background to its original black"
	varObj = arrayPlugin pluginValue ifFalse: [
		self setCurrentImages: context with: defaultImage ].

	self sendImages
]

{ #category : #accessing }
PluginSharedActions >> highlightPluginSelectorSend [
		"highlight Year/PercentSelector values with the chosen (valid value since checked in [variable of the class]: ) plugin value"

	"context is linked to an action value by the getSettings event which makes the plugin receive a didReceiveSettings event transmitting the action value, which is updated if keyUp: is triggered"

	"receives multiple times the same event, no need for a do: loop"

	| jsonSettings |
	arrayPlugin pluginSelectorSet do: [ :each |
		jsonSettings := self getSettings: each.
		arrayGetSettings add: jsonSettings.
		self sendGetSettings ]
]

{ #category : #'as yet unclassified' }
PluginSharedActions >> initServer [
	"Creates a ZnManagingMultiThreadedServer HTTP port 8080 process, which needs to be terminated 	through the Process Browser if another server is to be launched"

	| jsonObject server arrayPluginContents |
	"launchedServerState ifNil: [ launchedServerState := false ]."
	server := ZnWebSocket
		          startServerOn: 8080
		          prefix: 'pharoBridge'
		          do: [ :webSocket |
			          [
			          webSocket runWith: [ :message |
				          | event |
				          self launchedServerStateChange: true.

				          "gives the WebSocket to every plugin"
				          arrayPluginContents := arrayPlugin arrayPluginContents.
				          arrayPluginContents do: [ :each |
					          each WebSocket: webSocket ].
				          "self inform: 'Received message: ' , message printString."
				          "treats the data received accordingly, redirecting events to their respective method"
				          jsonObject := STONJSON fromString: message.
				          event := jsonObject at: 'event'.

				          "custom fields (i.e. ones that aren't required by an event as described in the SDK) are sent through the payload attribute of a JSON string"
				          "string associated to inRegisterEvent in JavaScript"
				          event = 'registerPlugin' ifTrue: [
					          self registerPluginEvent: jsonObject ].

				          "called when a key is pressed, is only a received event, doesn't need to be sent back to the plugin"
				          event = 'keyUp' ifTrue: [ self keyUpEvent: jsonObject ].

				          "called when one of the keys of the PharoStreamDeck plugin is present on the current displayed plugin"
				          event = 'willAppear' ifTrue: [
					          self willAppearEvent: jsonObject ].

				          event = 'willDisappear' ifTrue: [ self willDisappear ].
				          "setGlobalSettings getGlobalSettings, setTitle and setSettings are only invoked, they're not received as is"
				          "setTitle and setSettings are called when selecting a value from the Property Inspector list"

				          "setImage is directly received when the plugin receives the didReceiveGlobalSettings event in order to reset the backgrounds of the keys"
				          event = 'setImage' ifTrue: [
					          self setImageEvent: jsonObject ].

				          "received when the getSettings event is sent, is used to receive the year value through a context of a Year/PercentSelector instance"
				          event = 'didReceiveSettings' ifTrue: [
					          self highlightPluginSelectorReceive: jsonObject ].

				          "event received when a value is changed from the Property Inspector of a Year/PercentSelector instance"
				          event = 'sendToPlugin' ifTrue: [
					          self sendToPluginEvent: jsonObject ] ] ]
				          on: ConnectionClosed , PrimitiveFailed
				          do: [ "ignore close"
				          self launchedServerStateChange: false ].
			          self inform: 'The server is closed' ]
]

{ #category : #'as yet unclassified' }
PluginSharedActions >> initialize [

	super initialize.

	arraySetImage := OrderedCollection new.
	arrayGetSettings := OrderedCollection new.
	arrayPlugin := ArrayPlugin new.
]

{ #category : #accessing }
PluginSharedActions >> keyUp: jsonObj [
	"sends multiple events (setSettings, setGlobalSettings which sends getGlobalSettings so that the plugin receives a didReceiveGlobalSettings event)"

	| jsonSettings context arrayEvents jsonFormattedSettings highlightedImage jsonContext jsonWillAppear jsonFormattedWillAppear defaultImage varObj |
	"varObj being a year or a percent depending on the class it comes from"
	"action being only affected to a value in willAppear: and keyUp"
	action := jsonObj at: 'action'.
	context := jsonObj at: 'context'.

	defaultImage := 'img/actionIcon.png'.
	highlightedImage := 'img/actionIconHighlighted.png'.

	"resets value to 0 if a Year/PercentWitness is pressed (for setTitle and setSettings)"
	"checks for every plugin if its type is Witness"
	(arrayPlugin witnessAction includes: action) ifTrue: [ varObj := 0 ].
	
	"values need to be saved for each plugin"
	self determineTypeObj.
	(arrayPlugin selectorAction includes: action) ifTrue: [ 
		varObj := jsonObj at: 'payload' at: typeObj ].

	jsonSettings := Dictionary new
		                at: 'event' put: 'setSettings';
		                at: 'context' put: context;
		                at: typeObj put: varObj;
		                yourself.
	"STONJSON toString conversion is performed in setSettings, setGlobalSettings and getGlobalSettings"
	jsonFormattedSettings := self setSettings: jsonSettings.

	"setGlobalSettings and getGlobalSettings (called in setGlobalSettings) have no object given to them since their event is always the same, they just need a uuid and a year (the second one is only needed for setGlobalSettings) which are instance variables of the YearSelector class"
	jsonContext := Dictionary new
		               at: 'context' put: context;
		               at: typeObj put: varObj;
		               yourself.
	self setGlobalSettings: jsonContext.

	jsonWillAppear := Dictionary new
		                  at: 'action' put: action;
		                  at: 'context' put: context;
		                  yourself.
	jsonWillAppear at: 'payload' at: typeObj put: varObj.
	jsonFormattedWillAppear := (self willAppear: jsonWillAppear) at: 1.

	"used to reset keys highlighted by a command sent in the Pharo IDE using the MyApp class, these messages are sent before jsonFormattedSetHighlightedImage"
	arraySetImage := OrderedCollection new.

	arrayPlugin pluginWitnessSet do: [ :each |
		self setCurrentImages: each with: defaultImage ].

	arrayPlugin pluginSelectorSet do: [ :each |
		self setCurrentImages: each with: defaultImage ].
	
	self sendImages.

	"updates the instance variable year of the YearSelector class, which is needed to update the yearWitness instances through commands sent in the Pharo IDE"
	self sendValueHasChangedEvent: varObj.

	"returns the different events"
	arrayEvents := Array new: 2.
	"these attributes are all stringified JSON"
	arrayEvents at: 1 put: jsonFormattedSettings.
	arrayEvents at: 2 put: jsonFormattedWillAppear.

	^ arrayEvents
]

{ #category : #accessing }
PluginSharedActions >> keyUpEvent: jsonObject [

	| arrayEvents jsonSettings jsonWillAppear |
	arrayEvents := self keyUp: jsonObject.

	jsonSettings := arrayEvents at: 1.
	jsonWillAppear := arrayEvents at: 2.

	WebSocket sendMessage: jsonSettings.
	self sendUpdatePluginWitnessInstances
]

{ #category : #accessing }
PluginSharedActions >> launchedServer: server [

	launchedServer := server
]

{ #category : #accessing }
PluginSharedActions >> launchedServerStateChange: launchedServerState [

	launchedServer launchedServerState: launchedServerState
]

{ #category : #accessing }
PluginSharedActions >> modifyPluginWitnessValue [
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

{ #category : #accessing }
PluginSharedActions >> pluginValueSuperclass: aNumber [
	"verify that aNumber is equal to one of the numbers returned by the authorizedNumbers method, which are values transmitted from the Property Inspector."

	"also calls other methods to change every Year/PercentWitness instance's value as well as highlight Year/PercentSelector values with the chosen (valid) plugin value."

	| pluginValue |
	"for the current plugin, will still execute numberInAuthorizedNumbers: if the same percent value is active while the previous input was related to a YearSelector plugin value"
	pluginValue := arrayPlugin pluginValue.
	pluginValue = aNumber ifTrue: [ ^ self ].

	arrayPlugin numberInAuthorizedNumbers: aNumber
]

{ #category : #accessing }
PluginSharedActions >> registerPlugin: jsonObj [
	"the uuid field is only transmitted when registerPlugin() is called in index.html"

	"transmits the event to the first WebSocket since it isn't done in the JavaScript code"

	| uuidObj json |
	uuidObj := jsonObj at: 'uuid'.
	self uuid: uuidObj.

	json := STONJSON toString: jsonObj.
	^ json
]

{ #category : #accessing }
PluginSharedActions >> registerPluginEvent: jsonObject [

	| json |
	json := self registerPlugin: jsonObject.
	WebSocket sendMessage: json
]

{ #category : #accessing }
PluginSharedActions >> sendGetSettings [
	"gets the settings for every Year/PercentSelector instance by sending a setSettings event which adds a parameter to the settings of every instance, deleting it afterhand"

	"done that way since the setSettings event sent in keyUp is necessary to keep track of each instance's value, also calls a didReceiveSettings event which updated every Year/PercentSelector having the same value as the one clicked"

	arrayGetSettings do: [ :each | WebSocket sendMessage: each ].

	"removes the previous elements stocked in order to not stack multiple times the same context with different values"
	arrayGetSettings removeAll
]

{ #category : #accessing }
PluginSharedActions >> sendImages [
	"sends defaultImage or highlighting image depending on the sender for every Year/PercentSelector instance"

	arraySetImage do: [ :each | WebSocket sendMessage: each ].

	"removes the previous elements stocked in order to not stack multiple times the same context with different values"
	arraySetImage removeAll
]

{ #category : #accessing }
PluginSharedActions >> sendToPlugin: jsonObj [

	| newValue dictionaryNewValue context arrayEvents |
	newValue := jsonObj at: 'payload' at: 'setValue'.
	context := jsonObj at: 'context'.

	dictionaryNewValue := Dictionary new
		                      at: 'context' put: context;
		                      at: typeObj put: newValue;
		                      yourself.

	arrayEvents := Array new: 2.
	arrayEvents at: 1 put: (self setSettings: dictionaryNewValue).
	arrayEvents at: 2 put: (self setTitlePI: dictionaryNewValue).

	^ arrayEvents
]

{ #category : #accessing }
PluginSharedActions >> sendToPluginEvent: jsonObject [

	| arrayEvents jsonSettings jsonTitle |
	arrayEvents := self sendToPlugin: jsonObject.

	jsonSettings := arrayEvents at: 1.
	jsonTitle := arrayEvents at: 2.

	WebSocket sendMessage: jsonSettings.
	WebSocket sendMessage: jsonTitle
]

{ #category : #accessing }
PluginSharedActions >> sendUpdatePluginWitnessInstances [
	"updates every Year/PercentWitness instance"

	arrayPlugin arrayJSONSetTitleAndSettingsPluginWitness do: [ :each |
		WebSocket sendMessage: each ].

	"removes the previous elements stocked in order to not stack multiple times the same context with different values"
	arrayPlugin arrayJSONSetTitleAndSettingsPluginWitness removeAll
]

{ #category : #accessing }
PluginSharedActions >> sendValueHasChangedEvent: aNumber [
	"changes the plugin value, also update the value shown on relevant Witness instances and highlight the relevant Selector instances"
	self pluginValueSuperclass: aNumber.
	
	self modifyPluginWitnessValue.
	self highlightPluginSelectorSend
]

{ #category : #accessing }
PluginSharedActions >> setCurrentImages: context with: img [

	| jsonDefaultImage jsonFormattedImage |
	jsonDefaultImage := Dictionary new
		                    at: 'context' put: context;
		                    at: 'image' put: img;
		                    yourself.

	jsonFormattedImage := self setImage: jsonDefaultImage.
	arraySetImage add: jsonFormattedImage
]

{ #category : #accessing }
PluginSharedActions >> setGlobalSettings: jsonObj [
	"didReceiveGlobalSettings event is received after calling the getGlobalSettings API for the plugin, it is NOT called automatically when setGlobalSettings is called (the didReceiveGlobalSettings event isn't necessary for this plugin, since all major operations are done in the Pharo side of things"

	"this function serves to share the year/percent value between Year/PercentSelector actions and Year/PercentWitness actions, so that the instances of the second are informed when a change is made"

	"this function sets a new year/percent value to be shared between instances"

	"globalSettings events use a uuid for the context field, the name doesn't change"

	| jsonSetGlobalSettings jsonFormattedSetGlobalSettings varObj |
	varObj := jsonObj at: typeObj.

	jsonSetGlobalSettings := Dictionary new
		                         at: 'event' put: 'setGlobalSettings';
		                         at: 'context' put: uuid;
		                         "not put inside a settings field since the SDK takes care of this operation"
		                         at: 'payload'
		                         at: typeObj
		                         put: varObj;
		                         yourself.

	jsonFormattedSetGlobalSettings := STONJSON toString:
		                                  jsonSetGlobalSettings
]

{ #category : #accessing }
PluginSharedActions >> setImage: jsonObj [

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

{ #category : #accessing }
PluginSharedActions >> setImageEvent: jsonObject [

	| json |
	json := self setImage: jsonObject.
	WebSocket sendMessage: json
]

{ #category : #accessing }
PluginSharedActions >> setSettings: jsonObj [
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

{ #category : #accessing }
PluginSharedActions >> setTitle: jsonObj [

	| jsonFormattedTitle context jsonTitle jsonSettings jsonFormattedSettings arrayEvents varObj |
	context := jsonObj at: 'context'.
	varObj := jsonObj at: typeObj.

	"can also receive it from the setTitle event sent when the Property Inspector value of a YearSelector is changed"
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

{ #category : #accessing }
PluginSharedActions >> setTitleAndSettingsYearWitness: jsonObj [

	| context jsonTitle jsonFormattedTitle jsonSettings jsonFormattedSettings varObj |
	"this method is used to update every Year/PercentWitness instance through their context, which is the unique value that represents an instance""it updates their title as well as their settings, so that willAppear: can load their new values when changing profiles""used by getGlobalSettings: ""with context being each element sent to this method""the plugin value is saved in the plugin field, located in the payload field"
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
	"arrayJSONSetTitleAndSettingsPluginWitness := self
		                                             arrayJSONSetTitleAndSettingsPluginWitness."
	arrayPlugin arrayJSONSetTitleAndSettingsPluginWitness add:
		jsonFormattedTitle.
	arrayPlugin arrayJSONSetTitleAndSettingsPluginWitness add:
		jsonFormattedSettings
]

{ #category : #accessing }
PluginSharedActions >> setTitlePI: jsonObj [
	"for values received through the sendToPlugin event (value changed in the Property Inspector of a Year/PercentSelector instance)"

	"data persistence is limited to the launched server, as opposed to the JavaScript version of this plugn which has no constraint whatsoever"

	"this version operates without coordinates and instead uses the context value, since coordinates are not received by using the sendToPlugin event"

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

{ #category : #accessing }
PluginSharedActions >> uuid: anObject [

	"used for the globalSettings event (get and set) for their context field. These settings are preserved between instances, notably for the year variable"

	uuid := anObject
]

{ #category : #accessing }
PluginSharedActions >> willAppear: jsonObj [

	| context varObj subdictionary settings arrayEvents |
	context := jsonObj at: 'context'.
	action := jsonObj at: 'action'.
	self determineTypeObj.
	settings := jsonObj
		            at: 'payload'
		            at: typeObj
		            ifAbsent: [ settings := 0 ].

	"initialize every value to be 0 so that nil isn't shown"
	settings = 0 ifTrue: [ varObj := 0 ].
	settings = 0 ifFalse: [ varObj := settings ].

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

{ #category : #accessing }
PluginSharedActions >> willAppearEvent: jsonObject [

	| arrayEvents jsonTitle jsonSettings |
	arrayEvents := self willAppear: jsonObject.

	"settitle:  calls setSettings: "
	jsonTitle := arrayEvents at: 1.
	jsonSettings := arrayEvents at: 2.
	"updates every Year/PercentWitness value if the current Stream Deck profile is changed (default value being 0)"
	WebSocket sendMessage: jsonTitle.
	WebSocket sendMessage: jsonSettings
]

{ #category : #'as yet unclassified' }
PluginSharedActions >> willDisappear [
	"removes all yearWitness instances through their context as well as all setTitle events for yearWitness for the relevant Pharo class when the user changes to a profile that doesn't contain an instance of an action from the YearSelectorPharo plugin"

	arrayPlugin pluginWitnessSet removeAll.
	arrayPlugin pluginSelectorSet removeAll.
	arrayPlugin arrayJSONSetTitleAndSettingsPluginWitness removeAll
]
