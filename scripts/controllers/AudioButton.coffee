Spine = require 'Spine'
soundManager = require 'soundManager'

class AudioButton extends Spine.Controller
	source: ''

	className: 'audio-button'
	tag: 'button'

	sound: null

	events:
		'click': 'toggle'

	constructor: ->
		super

		@source ||= @el.attr 'data-audio-src'
		unless @source then return

		soundManager.onready =>
			@sound = soundManager.createSound
				id: @source.toString().replace /\W|[aeiou]/g, ''
				url: @source

				onload:   => @el.addClass 'loaded'
				onplay:   => @el.addClass 'playing'
				onstop:   => @el.removeClass 'playing'
				onfinish: => @el.removeClass 'playing'

			@sound.load()

	toggle: =>
		if @sound.playState isnt 1
			@sound.setPosition 0
			@sound.play()
		else
			@sound.stop()

exports = AudioButton
