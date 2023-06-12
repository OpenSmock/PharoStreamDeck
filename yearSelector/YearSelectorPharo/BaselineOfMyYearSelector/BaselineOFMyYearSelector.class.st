"
For the Class part:  I am the baseline used to import the MyYearSelector package as well as its primary dependency, Zinc

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
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
		baseline: #Zinc
		with: [ spec repository: 'https://github.com/svenvc/zinc' ]
]
