"
**For the Class part:** I am used to launch the application which can interact with the Stream Deck. There is no instances methods, only class methods. 

**For the Responsibility part:** When started, I create an array of tools which contains every instance of the possible actions implemented in the tool part of the `#'PharoStreamDeck'` package. I also start the server part.

**For the Collaborators Part:** My main collaborators is `SDPlugin` (server), which handles all the necessary operations (receives and sends events to the Stream Deck).

**How to start communicating with Stream Deck:** 
_SDAppLaunch start_.

**Class variables:**
- arrayTools : an `OrderedCollection` of tools (`SDSharedActions`)
- server : a `SDPlugin` used as server
"
Class {
	#name : 'SDAppLaunch',
	#superclass : 'Object',
	#classInstVars : [
		'arrayTools',
		'server'
	],
	#category : 'PharoStreamDeck-Core',
	#package : 'PharoStreamDeck-Core'
}

{ #category : 'accessing' }
SDAppLaunch class >> arrayTools [ 
	"Returns the list of tools"

	^ arrayTools 
]

{ #category : 'class cleaning' }
SDAppLaunch class >> cleanUp [ 
	"Restores to 'nil' plugins and the server"

	<script>
	
	arrayTools := nil.
	server := nil.
	
	"To implement : terminate the connection"
]

{ #category : 'accessing' }
SDAppLaunch class >> server [
	"Returns the SDPlugin used as server"

	^ server
]

{ #category : 'class initialization' }
SDAppLaunch class >> start [
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
		
	server := SDPlugin new
]

{ #category : 'see class side' }
SDAppLaunch >> seeClassSide [
]
