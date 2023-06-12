Class {
	#name : #BaselineOfMyYearSelector,
	#superclass : #BaselineOf,
	#category : #BaselineOfMyYearSelector
}

{ #category : #baselines }
BaselineOfMyYearSelector >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self dependencies: spec.
		spec package: #MyYearSelector ]
]

{ #category : #baselines }
BaselineOfMyYearSelector >> dependencies: spec [
	spec 
		baseline: #MyYearSelector
		with: [ spec repository: 'https://github.com/OpenSmock/PharoStreamDeck/tree/main/yearSelector/YearSelectorPharo' ].
	spec
		baseline: #ZincHTTPComponents
		with: [ spec repository: 'https://github.com/svenvc/zinc/repository' ]
]
