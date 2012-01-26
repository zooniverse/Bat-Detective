define (require) ->
	$ = require 'jQuery'

	SonogramPlayer = require 'controllers/SonogramPlayer'
	FrequencySelection = require 'controllers/FrequencySelection'

	class SonogramClassifier extends SonogramPlayer
		classifierEvents:
			'mousedown .sonogram': 'addFrequencyRange'

		constructor: ->
			$.extend @events, @classifierEvents
			super

		addFrequencyRange: (e) =>
			coord = e.pageY - @sonogram.offset().top
			percent = (clickY / @sonogram.height()) * 100

			@selection = new FrequencySelection
				model: @model.sounds().create()

			@selection.begin percent
