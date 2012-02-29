$ = require 'jQuery'

SonogramPlayer = require 'controllers/SonogramPlayer'
FrequencySelector = require 'controllers/FrequencySelector'

class SonogramClassifier extends SonogramPlayer
	subject: null
	classification: null

	classifierEvents:
		'mousedown .sonogram': 'addFrequencyRange'

	constructor: ->
		$.extend @events, @classifierEvents
		super

	setSubject: (@subject) =>
		super
		@classification = @subject.classifications().create {}

	addFrequencyRange: (e) =>
		e.preventDefault()

		y = 1 - (e.pageY - @sonogram.offset().top) / @sonogram.height()

		@selection = new FrequencySelector
			range: @classification.frequencyRanges().create
				low: y - 0.005
				high: y + 0.005
			mouseDown: e

		@selection.el.appendTo @imageContainer

exports = SonogramClassifier
