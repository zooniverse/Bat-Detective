Spine = require 'Spine'
$ = require 'jQuery'
soundManager = require 'soundManager'

translations = require 'translations'
{delay} = require 'util'

PLAYER_TEMPLATE = require 'lib/text!views/sonogramPlayer.html'

class SonogramPlayer extends Spine.Controller
	subject: null

	sound: null
	playing: false
	seeking: false
	wasPlaying: false

	className: 'sound-classifier'
	template: PLAYER_TEMPLATE

	events:
		'click .play': 'play'
		'click .pause': 'pause'
		'mousedown .seek': 'seekStart'

	elements:
		'.seek .track': 'track'
		'.seek .fill': 'fill'
		'.seek .thumb': 'thumb'
		'.image > .sonogram': 'sonogram'
		'.image > .seek-line': 'seekLine'
		'.details > .location > .value': 'location'
		'.details > .environment > .value': 'environment'
		'.details > .date > .value': 'date'
		'.details > .time > .value': 'time'

	constructor: ->
		super

		@el.html @template
		@refreshElements()

		@setSubject @subject

	delegateEvents: ->
		super
		$(document).on 'mousemove', @seekMove
		$(document).on 'mouseup', @seekEnd

	setSubject: (@subject) =>
		@sound?.destruct()
		soundManager.onready =>
			@sound = soundManager.createSound
				id: @subject.id or '_' + Math.floor Math.random() * 1000
				url: @subject.url

				autoload: true
				onload: @playerFinished
				onplay: @playerPlayed
				onpause: @playerPaused
				whileplaying: @playerTimeUpdated
				onfinish: @playerFinished

		@sonogram.attr 'src', @subject.image

		@location.html @subject.location
		@environment.html @subject.environment

		dt = new Date @subject.datetime

		@date.html """
			#{dt.getDate()}
			#{translations.months[dt.getMonth()]}
			#{dt.getFullYear()}
		"""
		@time.html """
			#{(dt.getHours() % 12) or 12}:#{dt.getMinutes()}
			#{if dt.getHours() < 12 then 'am' else 'pm'}
		"""

	play: =>
		@sound.play()

	pause: =>
		@sound.pause()

	seekStart: (e) =>
		e.preventDefault()

		@wasPlaying = @playing
		@pause()

		@seeking = true
		@el.addClass 'seeking'

		@seekMove(e)

	seekMove: (e) =>
		if not @seeking then return

		targetX = e.pageX - @track.offset().left
		percent = targetX / @track.width()
		percent = Math.min(Math.max(percent, 0), 1)

		@sound.setPosition percent * @sound.duration

	seekEnd: =>
		@seeking = false
		@el.removeClass 'seeking'

		if @wasPlaying then @play()

	playerPlayed: =>
		@playing = true
		@el.addClass 'playing'

	playerPaused: =>
		@playing = false
		@el.removeClass 'playing'

	playerTimeUpdated: =>
		percent = (@sound.position / @sound.duration) * 100

		@seekLine.css 'left', percent + '%'
		@fill.css 'width', percent + '%'
		@thumb.css 'left', percent + '%'

	playerFinished: =>
		# We always want the sound to be "playing", even when it's paused,
		# so that the whileplaying callback fires as we seek.
		@sound.play()
		@sound.pause()

exports = SonogramPlayer
