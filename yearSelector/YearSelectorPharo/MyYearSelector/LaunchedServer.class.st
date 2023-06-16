Class {
	#name : #LaunchedServer,
	#superclass : #Object,
	#instVars : [
		'launchedServer',
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
	"used in the initialize method of PluginSharedActions"

	^ launchedServerState
]

{ #category : #initialization }
LaunchedServer >> launchedServerState: aBoolean [
	"used in the initialize method of PluginSharedActions"

	launchedServerState := aBoolean
]
