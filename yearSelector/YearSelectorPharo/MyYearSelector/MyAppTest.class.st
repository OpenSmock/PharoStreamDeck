Class {
	#name : #MyAppTest,
	#superclass : #TestCase,
	#instVars : [
		'year'
	],
	#category : #MyYearSelector
}

{ #category : #tests }
MyAppTest >> testAppInitialize [

| m |
m := MyApp new.
self assert: m year equals: 0
]

{ #category : #tests }
MyAppTest >> testAppOtherYearValue [

| m |
m := MyApp new.
m year: 10.
self assert: m year equals: 10
]

{ #category : #tests }
MyAppTest >> testAppOtherYearValueFailed [

| m |
m := MyApp new.
m year: 32.
self assert: m year equals: 0
]
