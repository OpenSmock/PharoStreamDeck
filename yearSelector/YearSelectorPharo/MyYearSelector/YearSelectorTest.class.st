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
at: at: at: ifAbsentPut,
at: at: at: put:
needed to be implemented in the Dictionary class, 
located in the Collections-Unordered package included in Pharo by default"

| d settingsYear currentYear lastContext settingsLastContext |
currentYear := '2023'.
lastContext := '019'.
d := Dictionary new
	at: 'payload' at: 'settings' at: 'year' put: currentYear;
	at: 'payload' at: 'settings' at: 'lastContext' put: lastContext;
	yourself.

settingsYear := d at: 'payload' at: 'settings' at: 'year'.
settingsLastContext := d at: 'payload' at: 'settings' at: 'lastContext'.
self assert: settingsYear equals: currentYear.
self assert: settingsLastContext equals: lastContext
]

{ #category : #tests }
YearSelectorTest >> testEventField [
"can't include a test which would test the communication between JavaScript and Pharo since the WebSocket is contained in the initialize method, and can't be saved through a variable to be used to send a message to it. The only way is to follow in order the other data exchanges, starting with the Stream Deck to the plugin."
| y jsonObject json jsonFormatted event jsonGlobalSettings |
jsonObject := Dictionary new
	at: 'event' put: 'Event';
	at: 'uuid' put: 'UUID';
	yourself.

y := YearSelector new.
"no string conversion for these methods"
jsonGlobalSettings := y getGlobalSettings: jsonObject.
jsonFormatted := STONJSON fromString: jsonGlobalSettings.
event := jsonFormatted at: 'event'.
self assert: event equals: 'Event'
]

{ #category : #tests }
YearSelectorTest >> testOtherYearValue [

| y |
y := YearSelector new.
y year: 5.
self assert: y year equals: 5
]

{ #category : #tests }
YearSelectorTest >> testYearInitialize [

| y |
y := YearSelector new.
self assert: y year equals: 0
]
