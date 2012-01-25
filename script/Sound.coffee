define (require) ->
	Spine = require 'Spine'
	Clip = require 'Clip'

	class Sound extends Spine.Model
		high: NaN # 75000
		low: NaN # 50000

		maker: '' # "Bat" or "insect" or "machine"
		type: '' # "Social" or "searching" or "feeding"

		clips: null # [Clip, Clip, Clip]

		constructor: ->
			super
			@clips = []
