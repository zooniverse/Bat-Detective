define (require) ->
	Spine = require 'Spine'

	class Clip extends Spine.Model
		start: NaN
		end: NaN
