"
For the Class part:  I am used to launch only one server for multiple instances of PluginSharedActions, so that every instance knows if a server is launched or not

For the Responsibility part: if a server is set to nil, I set it to false. When a server is launched, launchedServerState (one of my instance variables) becomes true

For the Collaborators Part: PluginSharedActions so that every instance knows if a server is launched (a server being something of the type ZnManagingMultiThreadedServer HTTP port 8080).

How to create instances.
LaunchedServer new.

    Instance Variables
	launchedServer:		<Object>
	launchedServerState:		<Boolean>
"
Class {
	#name : #LaunchedServer,
	#superclass : #Object,
	#instVars : [
		'launchedServerState'
	],
	#category : #MyYearSelector
}

{ #category : #initialization }
LaunchedServer >> initialize [

	launchedServerState ifNil: [ launchedServerState := false ].
]

{ #category : #initialization }
LaunchedServer >> launchedServerState [
	"used in the initServer method of PluginSharedActions"

	^ launchedServerState
]

{ #category : #initialization }
LaunchedServer >> launchedServerState: aBoolean [
	"used in the initServer method of PluginSharedActions"

	launchedServerState := aBoolean
]
