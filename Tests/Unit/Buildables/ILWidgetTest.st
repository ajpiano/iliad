TestCase subclass: ILWidgetTest [
    | c1 c2 c3 c4 |

    <comment: nil>
    <category: 'Iliad-Tests-Unit-Buildables'>

    setUp [
	<category: 'running'>
	c1 := ILWidgetMock1 new.
	c2 := ILWidgetMock2 new.
	c3 := ILWidgetMock3 new.
	c4 := ILWidgetMock3 new
    ]

    testAnswer [
	<category: 'testing'>
	ILCurrentContext
	    use: (ILContext new session: ILSession new; yourself)
	    during: [
		c1 show: c2 onAnswer: [:ans | self assert: ans = 'hello'].
		c2 show: c3 onAnswer: [:ans | self assert: ans = 10].
		c3 answer: 10.
		c2 answer: 'hello'.
		c1 show: c2 onAnswer: [:ans | self assert: ans = 'hello'].
		c1 show: c3 onAnswer: [:ans | self assert: ans = 10].
		c2 answer: 'hello'.
		c3 answer: 10]
    ]

    testDecorators [
	<category: 'testing'>
	| d1 d2 d3 |
	d1 := ILDecorator new.
	d2 := ILDecorator new.
	d3 := ILDecorator new.
	c1 decorateWith: d1.
	self assert: d1 decoratee = c1.
	c1 decorateWith: d2.
	self assert: d1 decoratee = d2.
	self assert: d1 decoratee decoratee = c1.
	c1 decorateWith: d3.
	self assert: d1 decoratee = d2.
	self assert: d1 decoratee decoratee = d3.
	self assert: d1 decoratee decoratee decoratee = c1.
	d2 removeYourself.
	self assert: d1 decoratee = d3.
	self assert: d1 decoratee decoratee = c1.
	d3 removeYourself.
	self assert: d1 decoratee = c1
    ]

    testDependentWidget [
	<category: 'testing'>
	self withSessionDo: [
	    c3 addDependentWidget: c2.
	    c2 addDependentWidget: c1.

	    self assert: (self session dirtyWidgets isEmpty).
	    c3 markDirty.
	    self assert: (self session dirtyWidgets includes: c3).
	    self assert: (self session dirtyWidgets includes: c2).
	    self assert: (self session dirtyWidgets includes: c1)]
    ]

    testRetrieveControl [
	<category: 'testing'>
	| str |
	str := WriteStream on: ''.
	self withSessionDo: [
		c1 show: c2.
		c1 show: c3.
		c1 build printHtmlOn: str.
		self deny: ('*test widget 1*' match: str contents).
		c1 retrieveControl.
		str := WriteStream on: ''.
		c1 build printHtmlOn: str.
		self assert: ('*test widget 1*' match: str contents)]
    ]

    testShow [
	<category: 'testing'>
	| str |
	str := WriteStream on: ''.
	self withSessionDo: [
		c1 show: c2.
		c1 build printHtmlOn: str.
		self assert: (str contents matchRegex: '.*test widget 2.*').
		str := WriteStream on: ''.
		c2 show: c3.
		c1 build printHtmlOn: str.
		self assert: (str contents matchRegex: '.*test widget 3.*').
		str := WriteStream on: ''.
		c3 answer.
		c1 build printHtmlOn: str.
		self assert: (str contents matchRegex: '.*test widget 2.*').
		str := WriteStream on: ''.
		c2 answer.
		c1 build printHtmlOn: str.
		self assert: (str contents matchRegex: '.*test widget 1.*')]
    ]

    testDirtyWidget [
	<category: 'testing'>
	self withSessionDo: [
		self assert: (self session dirtyWidgets isEmpty).
		c1 markDirty.
		self assert: (self session dirtyWidgets includes: c1).
		self deny: (self session dirtyWidgets includes: c2).
		c2 markDirty.
		self assert: (self session dirtyWidgets includes: c1).
		self assert: (self session dirtyWidgets includes: c2).]
    ]

    session [
	<category: 'private'>
	^ILCurrentContext value session
    ]

    withSessionDo: aBlock [
	<category: 'private'>
	"To build widgets, we have to create a fake session,
	with a context, aRequest and an application"
	
	| context app request |
	request := ILRequest new.
	app := ILApplication new.
	context := ILContext new 
		application: app;
		session: ILSession new;
		request: request;
		yourself.
	ILCurrentContext 
		use: context
		during: [
		    context request url: (ILUrl absolute: '/').
		    context request fields: (Dictionary with: ('_state' -> context stateRegistry key)).	
		    context stateRegistry 
			register: c1;
			register: c2;
			register: c3.
		    app respondOn: ILResponse new.
		    aBlock value]
    ]
]

