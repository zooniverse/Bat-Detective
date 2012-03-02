$ = require 'jQuery'

SonogramPlayer = require 'controllers/SonogramPlayer'

FrequencySelector = require 'controllers/FrequencySelector'

Subject = require 'models/Subject'

class SonogramClassifier extends SonogramPlayer
	subject: null
	classification: null

	classifierEvents:
		'mousedown .sonogram': 'addFrequencyRange'
		'click .done': 'nextSubject'

	constructor: ->
		$.extend @events, @classifierEvents
		super

	setSubject: (@subject) =>
		selection.release() for selection in @selections or []
		@selections = []
		super
		@classification = @subject.classifications().create {}

	addFrequencyRange: (e) =>
		e.preventDefault()

		y = 1 - (e.pageY - @sonogram.offset().top) / @sonogram.height()

		selection = new FrequencySelector
			range: @classification.frequencyRanges().create
				low: y - 0.005
				high: y + 0.005
			mouseDown: e

		selection.el.appendTo @imageContainer
		@selections.push selection

	nextSubject: (e) =>
		@setSubject Subject.next()

exports = SonogramClassifier
