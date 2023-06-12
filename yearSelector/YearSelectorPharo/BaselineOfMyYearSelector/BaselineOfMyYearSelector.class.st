Class {
	#name : #BaselineOfMyYearSelector,
	#superclass : #Object,
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
		with: [ spec repository: 'https://github.com/OpenSmock/PharoStreamDeck/tree/main/yearSelector/YearSelectorPharo/MyYearSelector' ].
	spec
		baseline: #Zinc
		with: [ spec repository: 'https://github.com/svenvc/zinc' ]
]
