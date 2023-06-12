Class {
	#name : #BaselineOFMyYearSelector,
	#superclass : #Object,
	#category : #BaselineOfMyYearSelector
}

{ #category : #baselines }
BaselineOFMyYearSelector >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self dependencies: spec.
		spec package: #MyYearSelector ]
]

{ #category : #baselines }
BaselineOFMyYearSelector >> dependencies: spec [
	spec
		baseline: #Zinc
		with: [ spec repository: 'https://github.com/svenvc/zinc' ]
]
