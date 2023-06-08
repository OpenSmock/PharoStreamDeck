Extension { #name : #Dictionary }

{ #category : #'*MyYearSelector' }
Dictionary >> putIfAbsentInDictionary: aVal at: aVal2 at: aVal3 put: value [

	"equivalent to the previously implemented at: at: at: methods"
	"previous syntax looked like this: "
	"((jsonFormattedObject at: 'payload' ifAbsentPut: [ Dictionary new ])
		 at: 'settings'
		 ifAbsentPut: [ Dictionary new ]) at: 'year' put: yearObj."
	"self class being Dictionary"

	((self at: aVal ifAbsentPut: [ self class new ])
		 at: aVal2
		 ifAbsentPut: [ self class new ]) at: aVal3 put: value.
]
