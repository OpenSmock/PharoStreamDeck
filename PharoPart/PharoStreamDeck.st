Object subclass: #SDSharedActions
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDSharedActions commentStamp: 'Anonymous 6/26/2025 15:34' prior: 0!
**For the Class part:** I regroup methods common to every tools of my StreamDeck plugin. I am abstract, therefore, there is no utility in creating an instance of myself. 

See my subclasses for more information.

!


!SDSharedActions methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	self subclassResponsibility! !


!SDSharedActions methodsFor: 'action' stamp: '6/16/2025 16:10'!
pluginAction
	"Action executed following a keyUp with the same uuid"

	self subclassResponsibility! !


SDSharedActions subclass: #SDBrowseReferences
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDBrowseReferences commentStamp: 'Anonymous 6/26/2025 15:42' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is browsing the references of a selected piece of code in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDBrowseReferences new._!


!SDBrowseReferences methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.browsereferences'! !


!SDBrowseReferences methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid"

	self currentWorld activeHand keyboardFocus handleKeyDown: 
	(KeyboardEvent new 
		setType: #keydown 
		buttons: KeyboardEvent ctrlKeyMask + KeyboardEvent shiftKeyMask 
		position: 0@0
		keyValue: $n asInteger 
		charCode: $n asInteger
		hand: self currentWorld activeHand 
		stamp: Time millisecondClockValue ;
		key: KeyboardKey N)! !


SDSharedActions subclass: #SDPlayground
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDPlayground commentStamp: 'Anonymous 6/26/2025 15:44' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is the opening of a playground tab in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDPlayground new._!


!SDPlayground methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.playground'! !


!SDPlayground methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid
	Opens a playground window"

	ToolRegistry new openWorkspace! !


SDSharedActions subclass: #SDInspectIt
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDInspectIt commentStamp: 'Anonymous 6/26/2025 15:43' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is inspecting a selected piece of code in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDInspectIt new._!


!SDInspectIt methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.inspectit'! !


!SDInspectIt methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid"

	self currentWorld activeHand keyboardFocus handleKeyDown: 
	(KeyboardEvent new 
		setType: #keydown 
		buttons: KeyboardEvent ctrlKeyMask
		position: 0@0
		keyValue: $i asInteger 
		charCode: $i asInteger
		hand: self currentWorld activeHand 
		stamp: Time millisecondClockValue ;
		key: KeyboardKey I)! !


SDSharedActions subclass: #SDSaveImage
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDSaveImage commentStamp: 'Anonymous 6/26/2025 15:44' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is saving the current image in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDSaveImage new._!


!SDSaveImage methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.saveimage'! !


!SDSaveImage methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid
	Saves the Pharo image"

	(Smalltalk snapshot: true andQuit: false) hasSavedSuccessfully
		ifTrue: [ self inform: 'Image saved' ]! !


SDSharedActions subclass: #SDSystemBrowser
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDSystemBrowser commentStamp: 'Anonymous 6/26/2025 15:44' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is the opening of a System Browser tab in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SystemBrowseTab new._


!


!SDSystemBrowser methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid
	Opens a system browser window"

	ToolRegistry new openClassBrowser ! !


!SDSystemBrowser methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.systembrowse'! !


SDSharedActions subclass: #SDBrowseImplementors
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDBrowseImplementors commentStamp: 'Anonymous 6/26/2025 15:42' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is browsing the implementors of a selected piece of code in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDBrowseImplementors new._!


!SDBrowseImplementors methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.browseimplementors'! !


!SDBrowseImplementors methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid"
	
	self currentWorld activeHand keyboardFocus handleKeyDown: 
	(KeyboardEvent new 
		setType: #keydown 
		buttons: KeyboardEvent ctrlKeyMask
		position: 0@0
		keyValue: $m asInteger 
		charCode: $m asInteger
		hand: self currentWorld activeHand 
		stamp: Time millisecondClockValue ;
		key: KeyboardKey M)! !


SDSharedActions subclass: #SDPrintIt
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDPrintIt commentStamp: 'Anonymous 6/26/2025 15:44' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is printing the resulf of a selected piece of code's execution in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDPrintIt new._!


!SDPrintIt methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.printit'! !


!SDPrintIt methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid"
	
	self currentWorld activeHand keyboardFocus handleKeyDown: 
	(KeyboardEvent new 
		setType: #keydown 
		buttons: KeyboardEvent ctrlKeyMask
		position: 0@0
		keyValue: $p asInteger 
		charCode: $p asInteger
		hand: self currentWorld activeHand 
		stamp: Time millisecondClockValue ;
		key: KeyboardKey P)! !


SDSharedActions subclass: #SDFinder
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDFinder commentStamp: 'Anonymous 6/26/2025 15:43' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is the opening of a finder tab in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDFinder new._!


!SDFinder methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.finder'! !


!SDFinder methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid
	Opens a finder window"

	FinderUI open! !


SDSharedActions subclass: #SDGit
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDGit commentStamp: 'Anonymous 6/26/2025 15:43' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is the opening of a git/iceberg tab in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDGit new._!


!SDGit methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.git'! !


!SDGit methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid
	Opens a Git repository browser window"

	IceTipRepositoriesBrowser new open! !


SDSharedActions subclass: #SDChangeTheme
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDChangeTheme commentStamp: 'Anonymous 6/26/2025 15:42' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is the changing of UI theme in Pharo : dark theme or light theme.

**For the Responsibility part:** my main responsability is to receive operations that were previously done on the JavaScript side of things. I receive data from it and if the action UUID is mine, I do my action.

**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin`` class.

**How to create instances:**
_SDChangeTheme new._!


!SDChangeTheme methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.changetheme'! !


!SDChangeTheme methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid
	Changes the Pharo application theme, between dark and light themes"

	PharoDarkTheme isCurrent 
		ifTrue: [ PharoLightTheme beCurrent ] 
		ifFalse: [ PharoDarkTheme beCurrent ]! !


SDSharedActions subclass: #SDDebugIt
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDDebugIt commentStamp: 'Anonymous 6/26/2025 15:42' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is debugging a selected piece of code in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDDebugIt new._!


!SDDebugIt methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.debugit'! !


!SDDebugIt methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid"

	self currentWorld activeHand keyboardFocus handleKeyDown: 
	(KeyboardEvent new 
		setType: #keydown 
		buttons: KeyboardEvent ctrlKeyMask + KeyboardEvent shiftKeyMask 
		position: 0@0
		keyValue: $d asInteger 
		charCode: $d asInteger
		hand: self currentWorld activeHand 
		stamp: Time millisecondClockValue ;
		key: KeyboardKey D)! !


SDSharedActions subclass: #SDBrowseFullClass
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDBrowseFullClass commentStamp: 'Anonymous 6/26/2025 15:42' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is browsing the full class of a selected piece of code in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDBrowseFullClass new._!


!SDBrowseFullClass methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.browsefullclass'! !


!SDBrowseFullClass methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid"
	
	self currentWorld activeHand keyboardFocus handleKeyDown: 
	(KeyboardEvent new 
		setType: #keydown 
		buttons: KeyboardEvent ctrlKeyMask
		position: 0@0
		keyValue: $b asInteger 
		charCode: $b asInteger
		hand: self currentWorld activeHand 
		stamp: Time millisecondClockValue ;
		key: KeyboardKey B)! !


SDSharedActions subclass: #SDBrowseSenders
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDBrowseSenders commentStamp: 'Anonymous 6/26/2025 15:42' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is browsing the senders of a selected piece of code in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDBrowseSenders new._!


!SDBrowseSenders methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.browsesenders'! !


!SDBrowseSenders methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid"

	self currentWorld activeHand keyboardFocus handleKeyDown: 
	(KeyboardEvent new 
		setType: #keydown 
		buttons: KeyboardEvent ctrlKeyMask
		position: 0@0
		keyValue: $n asInteger 
		charCode: $n asInteger
		hand: self currentWorld activeHand 
		stamp: Time millisecondClockValue ;
		key: KeyboardKey N)! !


SDSharedActions subclass: #SDFileBrowser
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDFileBrowser commentStamp: 'Anonymous 6/26/2025 15:43' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is the opening of a file browser tab in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDFileBrowser new._!


!SDFileBrowser methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.filebrowser'! !


!SDFileBrowser methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid
	Opens a file browser window"

	StFileSystemPresenter open! !


SDSharedActions subclass: #SDSettings
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDSettings commentStamp: 'Anonymous 6/26/2025 15:44' prior: 0!
For the Class part: I an a tool of the PharoStreamDeck Plugin. The action associated with pressing my key is the opening of a setting tab in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.

**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDSetting new._!


!SDSettings methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.settings'! !


!SDSettings methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid
	Opens a settings window"

	SettingBrowser open! !


SDSharedActions subclass: #SDDoIt
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDDoIt commentStamp: 'Anonymous 6/26/2025 15:43' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is executing a selected piece of code in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDDoIt new._!


!SDDoIt methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.doit'! !


!SDDoIt methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid"
	
	self currentWorld activeHand keyboardFocus handleKeyDown: 
	(KeyboardEvent new 
		setType: #keydown 
		buttons: KeyboardEvent ctrlKeyMask
		position: 0@0
		keyValue: $d asInteger 
		charCode: $d asInteger
		hand: self currentWorld activeHand 
		stamp: Time millisecondClockValue ;
		key: KeyboardKey D)! !


SDSharedActions subclass: #SDTranscript
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Tools'!
!SDTranscript commentStamp: 'Anonymous 6/26/2025 15:45' prior: 0!
**For the Class part:** I am a tool part of the PharoStreamDeck Plugin. The action associated with pressing my key is opening the Transcript in Pharo.

**For the Responsibility part:** My main responsability is to receive operations that were previously done on the JavaScript side of the plugin and redirected by the `SDPlugin class`. I receive data from it and if the action UUID is mine, I do my action.
 
**For the Collaborators part:** my main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin. I inherint from the `SDSharedActions` and I get called in the `SDPlugin` class.

**How to create instances:**
_SDTranscript new._!


!SDTranscript methodsFor: 'accessing' stamp: '6/26/2025 15:51'!
uuidAction
	"Returns the action unique identifier"

	^ 'com.thales.pharostreamdeck.transcript'! !


!SDTranscript methodsFor: 'action' stamp: '6/26/2025 15:51'!
pluginAction
	"Action executed following a keyUp with the same uuid
	Opens a transcript window"
 
	ToolRegistry new openTranscript
	
	"or Transcript open"! !
Object subclass: #SDPlugin
	instanceVariableNames: 'serverStarted webSocket'
	classVariableNames: 'arrayTools'
	package: 'PharoStreamDeck-Core'!
!SDPlugin commentStamp: 'Anonymous 6/26/2025 15:24' prior: 0!
**For the Class part:** I am used to launch the server, to receive and send events to the Stream Deck.

**For the Responsibility part:** I launch a server then treat the different events that are received from _index.html_ (the JavaScript side of the plugin, which also sends some info about the Stream Deck at its launch). With the use of the `SDPlugin>>#initServer` method, each event is treated by the relevant Pharo class.

**For the Collaborators Part:** My main collaborator is the Stream Deck application, which permits the use of profiles and placing actions on its grid through the PharoStreamDeck plugin.

**How to create instances:**
_SDPlugin new._

**Instance variables:**
- webSocket : a `ZnWebSocket` launched in `SDPlugin>>#initServer` to send messages between _index.html_ and `SDSharedActions` tool instances contained in arrayTools
- serverStarted : a value that indicates if the server is launched or not

**Shared variables:**
- arrayTools : an `OrderedCollection` of tools (`SDSharedActions`)!


!SDPlugin methodsFor: 'accessing' stamp: '6/26/2025 15:29'!
uuid
	"Returns the plugin unique identifier"

	^ 'com.thales.pharostreamdeck'! !

!SDPlugin methodsFor: 'accessing' stamp: '6/26/2025 15:30'!
webSocket
	"Returns the webSocket launched to send and receive messages to/from the server"

	^ webSocket! !

!SDPlugin methodsFor: 'accessing' stamp: '6/23/2025 14:25'!
webSocket: aWebSocket
	"Sets the websocket to given parameter. The launched webSocket is used to send and receive messages to and from the server"

	webSocket := aWebSocket! !

!SDPlugin methodsFor: 'accessing' stamp: '6/16/2025 11:33'!
serverStarted
	"Indicates if the server is started (true) or not (nil)"

	^ serverStarted! !

!SDPlugin methodsFor: 'accessing' stamp: '6/26/2025 15:29'!
serverStarted: aBoolean
	"Allows to change the server's state: true or nil"

	serverStarted := aBoolean! !

!SDPlugin methodsFor: 'accessing' stamp: '6/26/2025 15:28'!
arrayTools
	"Returns the list of tools"

	^ arrayTools! !


!SDPlugin methodsFor: 'initialization' stamp: '6/26/2025 15:25'!
initialize
	"Creates the instance and starts the server if it hasn't been started yet"

	super initialize.

	arrayTools := SDAppLaunch arrayTools.
	self serverStarted ifNil: [ self initServer ]! !

!SDPlugin methodsFor: 'initialization' stamp: '6/26/2025 15:35'!
initServer
	"Creates a ZnWebSocket HTTP port 8080 process, which needs to be terminated through the Process Browser if another server must be launched"
	
	| server |
	
	"Creates a socket"
	server := ZnWebSocket
		startServerOn: 8080
		prefix: 'pharoBridge'
		do: [ :aWebSocket |
			
			"Socket connected"
			[ aWebSocket isConnected
				ifTrue: [
					self serverStarted: true.
					self webSocket: aWebSocket .
					aWebSocket runWith: [ :message |
						self inform: 'Received message: ' , message printString.
						self connected: aWebSocket receives: message ] ]
				ifFalse: [ self error: 'The socket isn''t connected' ] ]
			
			"Ignore close"
			on: ConnectionClosed , PrimitiveFailed
			do: [ self serverStarted: nil ].
			
			"Socket disconnected"
			self inform: 'The server is closed'.
			self serverStarted: nil.
			SDAppLaunch cleanUp ].! !


!SDPlugin methodsFor: 'connection' stamp: '6/26/2025 15:26'!
connected: aWebsocket receives: aMessage
	"Manages the receipt of socket messages according to their event type"

	| jsonObject event |

	"Retrieves the received information"
	jsonObject := STONJSON fromString: aMessage.
	event := jsonObject at: 'event'.

	"A connexion is started"
	event = 'registerPlugin' ifTrue: [ self registerPluginEvent: jsonObject ].
	
	"An action appears on the Stream Deck"
	event = 'willAppear' ifTrue: [ self willAppearEvent: jsonObject ].

	"An action key is pressed"
	event = 'keyUp' ifTrue: [ self keyUpEvent: jsonObject ].
! !


!SDPlugin methodsFor: 'actions' stamp: '6/26/2025 15:27'!
whichAction: anAction
	"Sends a message to the class corresponding to the socket message"

	"Finds the corresponding class and sends it a message to activate its action"
	arrayTools do: [ :aTool |
		(aTool uuidAction = anAction) ifTrue: [
			aTool pluginAction. 
			^ aTool ] ].
	
	"If no class is found"
	self error: 'There''s an issue with your plugin''s UUID'! !


!SDPlugin methodsFor: 'event' stamp: '6/26/2025 15:31'!
willDisappearEvent: jsonObj
	"When a action disappears from the Stream Deck"
	
	"To implement"

	^ self! !

!SDPlugin methodsFor: 'event' stamp: '6/26/2025 15:31'!
keyUpEvent: jsonObj
	"When a key is pressed, sends a message to the class corresponding."
	
	| actualPlugin |
	
	actualPlugin := self whichAction: (jsonObj at: 'action').
	
	^ actualPlugin ! !

!SDPlugin methodsFor: 'event' stamp: '6/26/2025 15:31'!
willAppearEvent: jsonObj
	"When a action appears on the Stream Deck"

	"Does nothing in particular here, just informs us that it works"
	self inform: jsonObj! !

!SDPlugin methodsFor: 'event' stamp: '6/26/2025 15:31'!
registerPluginEvent: aJSONObject
	"When a connexion is started, answers to the sender in order to validate the connection"

	webSocket sendMessage: (STONJSON toString: aJSONObject)! !


Object subclass: #SDAppLaunch
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'PharoStreamDeck-Core'!
!SDAppLaunch commentStamp: 'Anonymous 6/26/2025 15:15' prior: 0!
**For the Class part:** I am used to launch the application which can interact with the Stream Deck. There is no instances methods, only class methods. 

**For the Responsibility part:** When started, I create an array of tools which contains every instance of the possible actions implemented in the tool part of the `#'PharoStreamDeck'` package. I also start the server part.

**For the Collaborators Part:** My main collaborators is `SDPlugin` (server), which handles all the necessary operations (receives and sends events to the Stream Deck).

**How to start communicating with Stream Deck:** 
_SDAppLaunch start_.

**Class variables:**
- arrayTools : an `OrderedCollection` of tools (`SDSharedActions`)
- server : a `SDPlugin` used as server!


!SDAppLaunch methodsFor: 'see class side' stamp: '6/13/2025 10:24'!
seeClassSide! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SDAppLaunch class
	instanceVariableNames: 'arrayTools server'!
!SDAppLaunch class commentStamp: 'Anonymous 6/26/2025 15:15' prior: 0!
**For the Class part:** I am used to launch the application which can interact with the Stream Deck. There is no instances methods, only class methods. 

**For the Responsibility part:** When started, I create an array of tools which contains every instance of the possible actions implemented in the tool part of the `#'PharoStreamDeck'` package. I also start the server part.

**For the Collaborators Part:** My main collaborators is `SDPlugin` (server), which handles all the necessary operations (receives and sends events to the Stream Deck).

**How to start communicating with Stream Deck:** 
_SDAppLaunch start_.

**Class variables:**
- arrayTools : an `OrderedCollection` of tools (`SDSharedActions`)
- server : a `SDPlugin` used as server!


!SDAppLaunch class methodsFor: 'class initialization' stamp: '6/26/2025 15:17'!
start
	"Instantiates all tools from the plugin and launches the server"

	<script>
	
	arrayTools := OrderedCollection new.
	arrayTools
		add: SDChangeTheme new;
		add: SDFileBrowser new;
		add: SDFinder new;
		add: SDGit new;
		add: SDPlayground new;
		add: SDSaveImage new;
		add: SDSettings new;
		add: SDBrowseImplementors new;
		add: SDBrowseReferences new;
		add: SDPrintIt new;
		add: SDInspectIt new;
		add: SDDoIt new;
		add: SDDebugIt new;
		add: SDBrowseSenders new;
		add: SDBrowseFullClass new;
		add: SDTranscript new;
		add: SDSystemBrowser new.
		
	server := SDPlugin new! !


!SDAppLaunch class methodsFor: 'accessing' stamp: '6/26/2025 15:18'!
server
	"Returns the SDPlugin used as server"

	^ server! !

!SDAppLaunch class methodsFor: 'accessing' stamp: '6/26/2025 15:18'!
arrayTools 
	"Returns the list of tools"

	^ arrayTools ! !


!SDAppLaunch class methodsFor: 'class cleaning' stamp: '6/26/2025 15:19'!
cleanUp 
	"Restores to 'nil' plugins and the server"

	<script>
	
	arrayTools := nil.
	server := nil.
	
	"To implement : terminate the connection"! !
