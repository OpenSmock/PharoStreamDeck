"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  I execute tests for the class YearSelector.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	year:		<Object>


    Implementation Points
"
Class {
	#name : #YearSelectorTest,
	#superclass : #TestCase,
	#instVars : [
		'year'
	],
	#category : #MyYearSelector
}

{ #category : #tests }
YearSelectorTest >> testAccessDictionaryDepthThree [
"methods 
at: at: at:, 
at: at: at: ifAbsent,
putIfAbsentInDictionary: at: at: put: (which is equivalent to the at: at: at: put: method with ifAbsentPut: methods thrown in)
needed to be implemented in the Dictionary class, 
located in the Collections-Unordered package included in Pharo by default"

"can't include a test which would test the communication between JavaScript and Pharo since the WebSocket is contained in the initialize method, and can't be saved through a variable to be used to send a message to it. The only way is to follow in order the data exchanges, starting with the Stream Deck to the plugin."

| d settingsYear currentYear lastContext settingsLastContext |
currentYear := '2023'.
lastContext := '019'.

d := Dictionary new.
d putIfAbsentInDictionary: 'payload' at: 'settings' at: 'year' put: currentYear.
d putIfAbsentInDictionary: 'payload' at: 'settings' at: 'lastContext' put: lastContext.

settingsYear := d at: 'payload' at: 'settings' at: 'year'.
settingsLastContext := d at: 'payload' at: 'settings' at: 'lastContext'.

self assert: settingsYear equals: currentYear.
self assert: settingsLastContext equals: lastContext
]
