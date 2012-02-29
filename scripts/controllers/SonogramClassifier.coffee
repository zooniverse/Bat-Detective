$ = require 'jQuery'

SonogramPlayer = require 'controllers/SonogramPlayer'
FrequencySelection = require 'controllers/FrequencySelection'

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

	addFrequencyRange: ({pageY}) =>
		clickY = pageY - @sonogram.offset().top
		percent = (clickY / @sonogram.height()) * 100

		@selection = new FrequencySelection
			range: @classification.frequencyRanges().create {}

exports = SonogramClassifier
