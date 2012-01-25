define (require) ->
	Spine = require 'Spine'
	Sound = require 'Sound'

	class Sonogram extends Spine.Model
		image: '' # "/path/to/image.jpg"

		mp3: '' # "/path/to/audio.mp3"
		oga: '' # "/path/to/audio/oga"

		location: '' # "United Kingdom"
		environment: '' # "Urban area"
		datetime: NaN # 1327529045883

		sounds: null # [Sound, Sound, Sound]

		constructor: ->
			super
			@sounds ||= []
