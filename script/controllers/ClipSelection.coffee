define (require) ->
	Spine = require 'Spine'

	class ClipSelection extends Spine.Controller
		model: null