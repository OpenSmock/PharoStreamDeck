BaselineOf subclass: #BaselineOfPharoStreamDeck
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'BaselineOfPharoStreamDeck-Baseline'!

!BaselineOfPharoStreamDeck methodsFor: 'baselines' stamp: '4/15/2025 13:52'!
baseline: spec

	<baseline>
	spec for: #common do: [
		self dependencies: spec.
		spec package: #PharoStreamDeck ]! !


!BaselineOfPharoStreamDeck methodsFor: 'accessing' stamp: '4/15/2025 13:52'!
dependencies: spec

	spec
		baseline: 'ZincHTTPComponents'
		with: [ spec repository: 'github://svenvc/zinc/repository' ]! !
