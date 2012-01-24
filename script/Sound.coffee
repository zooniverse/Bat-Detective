define (require) ->
	Spine = require 'Spine'

	class Sound extends Spine.Model
		start: NaN
		end: NaN

		high: NaN
		low: NaN

		constructor: ->
			super
