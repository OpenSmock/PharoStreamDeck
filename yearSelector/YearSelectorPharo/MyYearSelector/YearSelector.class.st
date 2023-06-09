"
For the Class part: I represent a year selector, with values being specific integers (1, 5, 10, 15, 20).

For the Responsibility part: my main responsability is to choose a value and interact with the Elgato Stream Deck. As such, a value can be chosen through code or through a button press on the Stream Deck (see YearSelectorPharo Stream Deck profile).

For the Collaborators part: My main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on their grids through the YearSelector plugin.

How to create instances:
| yearSelector |
yearSelector := YearSelector new.

year isn't used anymore, since the year value that is shared between the instances of this plugin is transmitted through JSON data and events (setTitle and setSettings)
uuid is the unique value identifying the plugin (inPluginUUID in JavaScript code). It's sent via the registration procedure, so recuperated from the connectElgatoStreamDeckSocket() function (https://developer.elgato.com/documentation/stream-deck/sdk/registration-procedure/#compiled-plugin-registration) and is used in the setGlobalSettings: method for its context field, since globalSettings events require more than a context value to share a setting between instances of the plugin (see SDK documentation - events sent https://developer.elgato.com/documentation/stream-deck/sdk/events-sent/#setglobalsettings)
lastContext memorizes the context (being the unique value that can identify a Stream Deck key) of the key pressed before the last one, so that its background can be reset to its original black background
yearWitnessSet memorizes the context of every YearWitness instance, so that it can update them whenever a YearSelector instance is pressed. It's refilled every time the willAppear event is triggered, so when the YearSelectorPharo profile is the profile shown on the Stream Deck, for example
arrayJsonSetTitleYearWitness stocks the setTitle events that need to be sent to the plugin in order to update every YearWitness instance to showw the correct value pressed. It uses yearWitnessSet to know which Stream Deck keys are YearWitness instances
"
Class {
	#name : #YearSelector,
	#superclass : #Object,
	#instVars : [
		'year',
		'uuid',
		'lastContext',
		'yearWitnessSet',
		'arrayJsonSetTitleYearWitness'
	],
	#category : #MyYearSelector
}

{ #category : #accessing }
YearSelector >> authorizedNumbers [

	"these numbers are the only values permitted to be taken by a YearSelector through its Property Inspector"

	^ #( 0 5 10 15 20 )
]

{ #category : #accessing }
YearSelector >> getGlobalSettings: jsonObj [

	"not automatically called when setGlobalSettings is called, which is why this method is needed"

	"here, the getGlobalSettings event has no need to be sent to the plugin since the actions directly take place in Pharo"

	| defaultImage jsonSetImage jsonFormattedSetImage yearObj json |
	
	yearObj := jsonObj at: 'year'.
	
	"creates a link between yearWitnessSet and arrayJsonSetTitleYearWitness"
	yearWitnessSet do: [ :each | 
		json := Dictionary new
			        at: 'context' put: each;
			        at: 'year' put: yearObj;
			        yourself.
		self setTitleAndSettingsYearWitness: json ].

	defaultImage := 'img/actionIcon.png'.
	jsonSetImage := Dictionary new
		                at: 'context' put: lastContext;
		                at: 'image' put: defaultImage;
		                yourself.
	jsonFormattedSetImage := self setImage: jsonSetImage.

	^ jsonFormattedSetImage
]

{ #category : #accessing }
YearSelector >> initialize [

	| server json jsonObject arrayEvents jsonSettings jsonSetGlobalSettings jsonHighlightedImage jsonDefaultImage jsonTitle jsonWillAppear |
	super initialize.

	yearWitnessSet := OrderedCollection new.
	arrayJsonSetTitleYearWitness := OrderedCollection new.

	"Creates a ZnManagingMultiThreadedServer HTTP port 8080 process, which needs to be terminated 	through the Process Browser if another server is to be launched"
	server := ZnWebSocket
		          startServerOn: 8080
		          prefix: 'pharoBridge'
		          do: [ :webSocket | 
			          [ 
			          webSocket runWith: [ :message | 
				          | event |
				          "self inform: 'Received message: ' , message printString."
							"treats the data received accordingly, redirecting events to their respective method"
				          jsonObject := STONJSON fromString: message.
				          event := jsonObject at: 'event'.

				          "custom fields (i.e. ones that aren't required by an event as described in the SDK) are sent through the payload attribute of a JSON string"
				          "string associated to inRegisterEvent in JavaScript"
				          event = 'registerPlugin' ifTrue: [ 
					          json := self registerPlugin: jsonObject ].

				          "called when a key is pressed, is only a received event, doesn't need to be sent back to the plugin"
				          event = 'keyUp' ifTrue: [ 
					          arrayEvents := self keyUp: jsonObject.

					          jsonSettings := arrayEvents at: 1.
					          jsonSetGlobalSettings := arrayEvents at: 2.
					          jsonHighlightedImage := arrayEvents at: 3.
					          jsonDefaultImage := arrayEvents at: 4.
					          jsonWillAppear := arrayEvents at: 5.

					          webSocket sendMessage: jsonSettings.
					          webSocket sendMessage: jsonSetGlobalSettings.
					          webSocket sendMessage: jsonHighlightedImage.
					          webSocket sendMessage: jsonDefaultImage.
					          webSocket sendMessage: jsonWillAppear.

					          self sendUpdateYearWitnesses: webSocket ].

				          "called when one of the keys of the YearSelectorPharo plugin is present on the current displayed plugin"
				          event = 'willAppear' ifTrue: [ 
					          arrayEvents := self willAppear: jsonObject.

					          jsonTitle := arrayEvents at: 1.
					          jsonSettings := arrayEvents at: 2.
					          "updates every yearWitness value if the current Stream Deck profile is changed (default value being 0)"
					          webSocket sendMessage: jsonTitle.
					          webSocket sendMessage: jsonSettings ].

				          event = 'willDisappear' ifTrue: [ self willDisappear ].
				          "setGlobalSettings getGlobalSettings, setTitle and setSettings are only invoked, they're not received as is"
				          "setTitle and setSettings are called when selecting a value from the Property Inspector list"

				          "setImage is directly received when the plugin received the didReciveGlobalSettings event in order to reset the background of the last key pressed"
				          event = 'setImage' ifTrue: [ 
					          json := self setImage: jsonObject ].

				          "event received when a value is changed from the Property Inspector of a YearSeletor instance"
				          event = 'sendToPlugin' ifTrue: [ 
					          arrayEvents := self sendToPlugin: jsonObject.

					          jsonSettings := arrayEvents at: 1.
					          jsonTitle := arrayEvents at: 2.

					          webSocket sendMessage: jsonSettings.
					          webSocket sendMessage: jsonTitle ].

				          event = 'keyUp' | (event = 'sendToPlugin')
				          | (event = 'willAppear') ifFalse: [ 
					          webSocket sendMessage: json ] ] ]
				          on: ConnectionClosed , PrimitiveFailed
				          do: [ "ignore close" ].
			          self inform: 'The server is closed' ]
]

{ #category : #accessing }
YearSelector >> keyUp: jsonObj [

	"sends multiple events (setSettings, setGlobalSettings which sends getGlobalSettings so that the plugin receives a didReceiveGlobalSettings event)"

	| jsonSettings context arrayEvents jsonFormattedSettings jsonFormattedSetGlobalSettings settings coordinates jsonFormattedSetDefaultImage arrayGlobalSettings jsonSetHighlightedImage jsonFormattedSetHighlightedImage highlightedImage jsonContext yearObj action jsonWillAppear jsonFormattedWillAppear |
	action := jsonObj at: 'action'.
	context := jsonObj at: 'context'.
	settings := jsonObj at: 'payload' at: 'settings'.
	coordinates := jsonObj at: 'coordinates'.
	highlightedImage := 'img/actionIconHighlighted.png'.

	"resets value to 0 if a yearWitness is pressed (for setTitle and setSettings)"
	action = 'com.thales.yearselectorpharo.yearwitness' ifTrue: [ 
		settings := 0.
		yearObj := 0 ].

	action = 'com.thales.yearselectorpharo.action' ifTrue: [ 
		yearObj := settings at: 'year' ].

	jsonSettings := Dictionary new
		                at: 'event' put: 'setSettings';
		                at: 'context' put: context;
		                at: 'year' put: yearObj;
		                yourself.
	"STONJSON toString conversion is performed in setSettings, setGlobalSettings and getGlobalSettings"
	jsonFormattedSettings := self setSettings: jsonSettings.

	"setGlobalSettings and getGlobalSettings (called in setGlobalSettings) have no object given to them since their event is always the same, they just need a uuid and a year (the second one is only needed for setGlobalSettings) which are class variables of the YearSelector class"
	jsonContext := Dictionary new
		               at: 'context' put: context;
		               at: 'year' put: yearObj;
		               yourself.
	arrayGlobalSettings := self setGlobalSettings: jsonContext.

	jsonFormattedSetGlobalSettings := arrayGlobalSettings at: 1.
	jsonFormattedSetDefaultImage := arrayGlobalSettings at: 2.

	jsonSetHighlightedImage := Dictionary new
		                           at: 'context' put: context;
		                           at: 'image' put: highlightedImage;
		                           yourself.
	jsonFormattedSetHighlightedImage := self setImage:
		                                    jsonSetHighlightedImage.

	jsonWillAppear := Dictionary new
		                  at: 'action' put: action;
		                  at: 'context' put: context;
		                  at: 'payload'
		                  at: 'settings'
		                  at: 'year'
		                  put: yearObj;
		                  yourself.
	jsonFormattedWillAppear := (self willAppear: jsonWillAppear) at: 1.

	"used to remember last key pressed"
	self lastContext: context.

	"returns the different events"
	arrayEvents := Array new: 5.
	"these attributes are all stringified JSON"
	arrayEvents at: 1 put: jsonFormattedSettings.
	arrayEvents at: 2 put: jsonFormattedSetGlobalSettings.
	arrayEvents at: 3 put: jsonFormattedSetDefaultImage.
	arrayEvents at: 4 put: jsonFormattedSetHighlightedImage.
	arrayEvents at: 5 put: jsonFormattedWillAppear.

	^ arrayEvents
]

{ #category : #accessing }
YearSelector >> lastContext: anObject [

	"used to keep track of the context of the key pressed before the last one, so that its background can be reset to black"

	lastContext := anObject
]

{ #category : #accessing }
YearSelector >> registerPlugin: jsonObj [

	"the uuid field is only transmitted when registerPlugin() is called in index.html"

	"transmits the event to the first WebSocket since it isn't done in the JavaScript code"

	| uuidObj json |
	
	uuidObj := jsonObj at: 'uuid'.
	self uuid: uuidObj.

	json := STONJSON toString: jsonObj.
	^ json
]

{ #category : #accessing }
YearSelector >> sendToPlugin: jsonObj [

	| newValue dictionaryNewValue context arrayEvents |
	
	newValue := jsonObj at: 'payload' at: 'setValue'.
	context := jsonObj at: 'context'.

	dictionaryNewValue := Dictionary new
		                      at: 'context' put: context;
		                      at: 'year' put: newValue;
		                      yourself.

	arrayEvents := Array new: 2.
	arrayEvents at: 1 put: (self setSettings: dictionaryNewValue).
	arrayEvents at: 2 put: (self setTitlePI: dictionaryNewValue).

	^ arrayEvents
]

{ #category : #accessing }
YearSelector >> sendUpdateYearWitnesses: webSocket [

	"updates every yearWitness instance"

	arrayJsonSetTitleYearWitness do: [ :each | 
		webSocket sendMessage: each ].

	"removes the previous elements stocked in order to not stack multiple times the same context with different values"
	arrayJsonSetTitleYearWitness removeAll: arrayJsonSetTitleYearWitness
]

{ #category : #accessing }
YearSelector >> setGlobalSettings: jsonObj [

	"didReceiveGlobalSettings event is received after calling the getGlobalSettings API for the plugin, it is NOT called automatically when setGlobalSettings is called (the didReceiveGlobalSettings event isn't necessary for this plugin, since all major operations are done in the Pharo side of things"

	"this function serves to share the year value between YearSelector actions and YearWitness actions, so that the instances of the second are informed when a change is made"

	"this function sets a new lastContext and year value to be shared between instances"

	"globalSettings events use a uuid for the context field, the name doesn't change"

	| jsonSetGlobalSettings jsonFormattedSetGlobalSettings settings arrayGlobalSettings jsonFormattedSetDefaultImage yearObj jsonGlobalSettings |
	yearObj := jsonObj at: 'year'.

	"these two fields are not put inside a settings field since the SDK takes care of this operation"
	settings := Dictionary new
		            at: 'year' put: yearObj;
		            at: 'lastContext' put: lastContext;
		            yourself.

	jsonSetGlobalSettings := Dictionary new
		                         at: 'event' put: 'setGlobalSettings';
		                         at: 'context' put: uuid;
		                         at: 'payload' put: settings;
		                         yourself.
	jsonFormattedSetGlobalSettings := STONJSON toString:
		                                  jsonSetGlobalSettings.
	"is used to treat the data that would normally be treated by the didReceiveGlobalSettings event but is executed in Pharo this time around"
	"getGlobalSettings only returns the default image that needs to be sent to the plugin, changing the yearWitness titles is done in setTitleYearWitness where arrayJson (instance variable of the YearSelector class) stocks all the necessary events to send to the plugin"
	jsonGlobalSettings := Dictionary new
		                      at: 'year' put: yearObj;
		                      yourself.
	jsonFormattedSetDefaultImage := self getGlobalSettings:
		                                jsonGlobalSettings.

	arrayGlobalSettings := Array new: 2.
	arrayGlobalSettings at: 1 put: jsonFormattedSetGlobalSettings.
	arrayGlobalSettings at: 2 put: jsonFormattedSetDefaultImage.

	^ arrayGlobalSettings
]

{ #category : #accessing }
YearSelector >> setImage: jsonObj [

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
YearSelector >> setSettings: jsonObj [

	"settings save data persistently, such as a value selected in the Property Inspector for a YearSelector"

	"function called from keyUp: and sendToPlugin: "

	| jsonFormattedObject context yearObj jsonSettings |
	
	context := jsonObj at: 'context'.
	yearObj := jsonObj at: 'year'.

	jsonFormattedObject := Dictionary new
		                       at: 'event' put: 'setSettings';
		                       at: 'context' put: context;
		                       at: 'payload'
		                       at: 'settings'
		                       at: 'year'
		                       put: yearObj;
		                       yourself.
	jsonSettings := STONJSON toString: jsonFormattedObject.

	^ jsonSettings
]

{ #category : #accessing }
YearSelector >> setTitle: jsonObj [

	| jsonFormattedTitle context yearObj jsonTitle action jsonSettings jsonFormattedSettings arrayEvents |
	action := jsonObj at: 'action'.
	context := jsonObj at: 'context'.
	yearObj := jsonObj at: 'year'.

	"receives it from the setTitle event sent when the Property Inspector value of a YearSelector is changed"
	jsonTitle := Dictionary new
		                       at: 'event' put: 'setTitle';
		                       at: 'context' put: context;
		                       "conversion to string to be displayed on the Stream Deck keys"
		                       at: 'payload'
		                       at: 'title'
		                       put: yearObj asString;
		                       "value associated to DestinationEnum.HARDWARE_AND_SOFTWARE"
		                       at: 'target'
		                       put: 0;
		                       yourself.
	jsonFormattedTitle := STONJSON toString: jsonTitle.

	"needs to update internal data so that there exists no disconnect between the display (through setTitle) and the data pertaining to each instance (thorough setSettings)"
	jsonSettings := Dictionary new
		                at: 'context' put: context;
		                at: 'year' put: yearObj;
		                yourself.
	jsonFormattedSettings := self setSettings: jsonSettings.

	arrayEvents := Array new: 2.
	arrayEvents at: 1 put: jsonFormattedTitle.
	arrayEvents at: 2 put: jsonFormattedSettings.
	
	^ arrayEvents
]

{ #category : #accessing }
YearSelector >> setTitleAndSettingsYearWitness: jsonObj [

	| yearObj context jsonTitle jsonFormattedTitle jsonSettings jsonFormattedSettings |
	"this method is used to update every yearWitness instance through their context, which is the unique value that represents an instance""
	it updates their title as well as their settings, so that willAppear: can load their new values when changing profiles"
	"used by getGlobalSettings: "
	"with context being each element sent to this method"
	context := jsonObj at: 'context'.
	yearObj := jsonObj at: 'year'.

	"loop so that every yearWitness instance is updated"
	jsonTitle := Dictionary new
		             at: 'event' put: 'setTitle';
		             at: 'context' put: context;
		             "cast to string to be displayed on the Stream Deck keys"
		             at: 'payload'
		             at: 'title'
		             put: yearObj asString;
		             "value associated to DestinationEnum.HARDWARE_AND_SOFTWARE"
		             at: 'target'
		             put: 0;
		             yourself.
	jsonFormattedTitle := STONJSON toString: jsonTitle.

	jsonSettings := Dictionary new
		                at: 'event' put: 'setSettings';
		                at: 'context' put: context;
		                at: 'payload'
		                at: 'settings'
		                at: 'year'
		                put: yearObj;
		                yourself.
	jsonFormattedSettings := STONJSON toString: jsonSettings.

	"is used to send all the setTitle and setSettings events that are necessary when more than one YearWitness instance is present on the current displayed Stream Deck profile"
	arrayJsonSetTitleYearWitness add: jsonFormattedTitle.
	arrayJsonSetTitleYearWitness add: jsonFormattedSettings
]

{ #category : #accessing }
YearSelector >> setTitlePI: jsonObj [

	"for values received through the sendToPlugin event (value changed in the Property Inspector of a YearSelector instance)"

	"data persistence is limited to the launched server, as opposed to the JavaScript version of this plugn which has no constraint whatsoever"

	"this version operates without coordinates and instead uses the context value, since coordinates are not received by using the sendToPlugin event"

	| jsonFormattedObject context yearObj jsonTitle |
	
	context := jsonObj at: 'context'.
	yearObj := jsonObj at: 'year'.

	"receives it from the setTitle event sent when the Property Inspector value of a YearSelector is changed"
	self year: yearObj.

	jsonFormattedObject := Dictionary new
		                       at: 'event' put: 'setTitle';
		                       at: 'context' put: context;
		                       "conversion to string to be displayed on the Stream Deck keys"
		                       at: 'payload'
		                       at: 'title'
		                       put: yearObj asString;
		                       "value associated to DestinationEnum.HARDWARE_AND_SOFTWARE"
		                       at: 'target'
		                       put: 0;
		                       yourself.
	jsonTitle := STONJSON toString: jsonFormattedObject.
	
	^ jsonTitle
]

{ #category : #accessing }
YearSelector >> uuid: anObject [

	"used for the globalSettings event (get and set) for their context field. These settings are preserved between instances, notably for the year variable"

	uuid := anObject
]

{ #category : #accessing }
YearSelector >> willAppear: jsonObj [

	| context yearObj action subdictionary settings arrayEvents |
	context := jsonObj at: 'context'.
	action := jsonObj at: 'action'.
	settings := jsonObj
		            at: 'payload'
		            at: 'settings'
		            ifAbsent: [ settings := 0 ].

	"initialize every value to be 0 so that nil isn't shown"
	settings = 0 ifTrue: [ yearObj := 0 ].
	settings = 0 ifFalse: [ yearObj := settings at: 'year' ].

	"no punctuation apart from the dots that act as separators for the unique identifier"
	action = 'com.thales.yearselectorpharo.yearwitness' ifTrue: [ "context is globally unique across all actions, identifies an instance of an action on the Stream Deck but changes when the Stream Deck application is relaunched, also changes when actions are duplicated or moved" 
		yearWitnessSet add: context ].

	subdictionary := Dictionary new
		                 at: 'event' put: 'willAppear';
		                 at: 'action' put: action;
		                 at: 'context' put: context;
		                 at: 'year' put: yearObj;
		                 yourself.

	arrayEvents := self setTitle: subdictionary.

	^ arrayEvents
]

{ #category : #'as yet unclassified' }
YearSelector >> willDisappear [

	"removes all yearWitness instances through their context, as well as all setTitle events for yearWitness when the user changes to a profile that doesn't contain an instance of an action from the YearSelectorPharo plugin"

	yearWitnessSet removeAll: yearWitnessSet.
	arrayJsonSetTitleYearWitness removeAll: arrayJsonSetTitleYearWitness
]

{ #category : #accessing }
YearSelector >> year: anObject [

	"verify that anObject is equal to one of the numbers returned by the authorizedNumbers method, which are values transmitted from the Property Inspector."
	"This global variable is no longer necessary for the YearSelector class"

	| numbers |
	numbers := self authorizedNumbers.

	1 to: numbers size do: [ :i | 
	anObject = (numbers at: i) ifTrue: [ year := anObject ] ]
]
