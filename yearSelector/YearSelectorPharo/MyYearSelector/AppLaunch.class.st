Class {
	#name : #AppLaunch,
	#superclass : #Object,
	#instVars : [
		'myApp',
		'pharostreamdeck'
	],
	#category : #MyYearSelector
}

{ #category : #initialization }
AppLaunch >> initialize [
	"AppLaunch new is the correct way of initializing this application, NOT MyApp new"
	pharostreamdeck := PharoStreamDeckGUI new.
	myApp := MyApp new.
	
	myApp initGUI: pharostreamdeck.
	pharostreamdeck myApp: myApp.
	
	super initialize.
]

{ #category : #initialization }
AppLaunch >> percent [

	^ myApp percent
]

{ #category : #initialization }
AppLaunch >> percent: aPercent [

	myApp percent: aPercent
]

{ #category : #initialization }
AppLaunch >> year [

	^ myApp year
]

{ #category : #initialization }
AppLaunch >> year: aYear [

	myApp year: aYear
]
