Class {
	#name : 'BaselineOfPharoStreamDeck',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPharoStreamDeck',
	#package : 'BaselineOfPharoStreamDeck'
}

{ #category : 'baselines' }
BaselineOfPharoStreamDeck >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self dependencies: spec.
		spec package: 'PharoStreamDeck' ;
			package: 'PharoStreamDeck-Tests' ;
			package: 'PharoStreamDeck-Tools' ]
]

{ #category : 'accessing' }
BaselineOfPharoStreamDeck >> dependencies: spec [ 

	spec
		baseline: 'ZincHTTPComponents'
		with: [ spec repository: 'github://svenvc/zinc/repository' ]

]
