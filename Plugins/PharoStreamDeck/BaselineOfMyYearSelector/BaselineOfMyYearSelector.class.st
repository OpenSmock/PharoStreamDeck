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
	spec baseline: 'ZincHTTPComponents' with: [ spec repository: 'github://svenvc/zinc/repository' ].
]
