"
**For the Class Part:** I am used to launch the application which can interact with the Stream Deck. There is no instances methods, only class. 

**For the Responsibility Part:** When started, I create an array of plugin which contains every instance of the possible actions. I also start the server part.

**For the Collaborators Part:** My main collaborators is SDPlugin, which handles all the necessary operations (receives and sends events to the Stream Deck).


**How to start communicating with Stream Deck:** 
SDAppLaunch start.

**Class variables:**
arrayPlugin : contains an instance of every plugin.
server: permits to keep in memory the websocket used for communication with the Stream Deck .

"
Class {
	#name : 'SDAppLaunch',
	#superclass : 'Object',
	#classInstVars : [
		'arrayPlugin',
		'server'
	],
	#category : 'PharoStreamDeck-Core',
	#package : 'PharoStreamDeck',
	#tag : 'Core'
}

{ #category : 'accessing' }
SDAppLaunch class >> arrayPlugin [ 
^arrayPlugin 
]

{ #category : 'accessing' }
SDAppLaunch class >> server [

	^ server
]

{ #category : 'class initialization' }
SDAppLaunch class >> start [

	<script>
	arrayPlugin := OrderedCollection new.
	arrayPlugin
		add: ChangeTheme new;
		add: FileBrowserTab new;
		add: FinderTab new;
		add: GitTab new;
		add: PlaygroundTab new;
		add: SaveImage new;
		add: SettingTab new;
		add: SystemBrowseTab new.
		
	server := SDPlugin new
]
