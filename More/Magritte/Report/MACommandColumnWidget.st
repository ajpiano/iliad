"======================================================================
|
|   Magritte.MACommandColumnWidget class definition
|
 ======================================================================"

"======================================================================
|
| Copyright (c) 2008-2010 
| Nicolas Petton <petton.nicolas@gmail.com>,
| Sébastien Audier <sebastien.audier@gmail.com>
|
| Adapted from Magritte-Seaside written by Lukas Renggli 
| http://source.lukas-renggli.ch/magritte.
|
| This file is part of the Iliad framework.
|
| Permission is hereby granted, free of charge, to any person obtaining
| a copy of this software and associated documentation files (the 
| 'Software'), to deal in the Software without restriction, including 
| without limitation the rights to use, copy, modify, merge, publish, 
| distribute, sublicense, and/or sell copies of the Software, and to 
| permit persons to whom the Software is furnished to do so, subject to 
| the following conditions:
|
| The above copyright notice and this permission notice shall be 
| included in all copies or substantial portions of the Software.
|
| THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
| EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
| MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
| IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
| CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
| TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
| SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.  
|
 ======================================================================"



MAActionColumnWidget subclass: MACommandColumnWidget [
    | commands |
    
    <comment: nil>
    <category: 'Iliad-More-Magritte-Report'>

    addCommand: aBlock text: aString [
	<category: 'actions'>
	self addCommand: aBlock text: aString hash: [:val | '']
    ]

    addCommand: aBlock text: aString hash: anotherBlock [
	<category: 'actions'>
	self commands add: (aBlock -> anotherBlock) -> aString
    ]

    addCommandOn: anObject selector: aSelector [
	<category: 'actions'>
	self 
	    addCommandOn: anObject
	    selector: aSelector
	    text: aSelector allButLast asCapitalizedPhrase
    ]

    addCommandOn: anObject selector: aSelector text: aString [
	<category: 'actions'>
	self addCommand: (DirectedMesssage receiver: anObject selector: aSelector)
	    text: aString
    ]

    buildCellFormContent: anObject [
	<category: 'building'>
	^[:e | 
	    self commands do: 
		[:each | 
		    (e submitButton)
			action: [each key key value: anObject]
			hash: [each key value value: anObject];
			text: each value]
		separatedBy: [e space]]
    ]

    buildCellLinkContent: anObject [
	<category: 'building'>
	^[:e | 
	    self commands
		do: [:each | 
		    e a
			action: [each key key value: anObject]
			hash: (each key value value: anObject);
			text: each value]
		separatedBy: [e space]]
    ]

    commands [
	<category: 'accessing'>
	^commands
    ]

    commands: aCollection [
	<category: 'accessing'>
	commands := aCollection
    ]

    initialize [
	<category: 'initialization'>
	super initialize.
	self commands: OrderedCollection new
    ]
]

