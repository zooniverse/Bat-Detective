define (require) ->
	Spine = require 'Spine'

	class FrequencySelection extends Spine.Controller
		startAt: NaN
		model: null

		# Called when the mouse is initially put down on the sonogram
		beginSelection: (percent) ->
