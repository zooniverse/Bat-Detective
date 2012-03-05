Spine = require 'Spine'
$ = require 'jQuery'
soundManager = require 'soundManager'

translations = require 'translations'
{delay} = require 'util'

PLAYER_TEMPLATE = require 'lib/text!views/SonogramPlayer.html'

class SonogramPlayer extends Spine.Controller
	subject: null

	sound: null
	playing: false
	seeking: false
	wasPlaying: false

	className: 'sonogram-classifier'
	template: PLAYER_TEMPLATE

	events:
		'click .play': 'play'
		'click .pause': 'pause'
		'mousedown .seek': 'seekStart'

	elements:
		'.seek .track': 'track'
		'.seek .fill': 'fill'
		'.seek .thumb': 'thumb'
		'.image': 'imageContainer'
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
				url: @subject.audio

				onload: @playerLoaded
				onplay: @playerPlayed
				whileplaying: @playerTimeUpdated
				onpause: @playerPaused
				onfinish: @playerFinished

			@sound.load()

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
		@log 'Player will seek'
		e.preventDefault()

		@wasPlaying = @playing
		@pause()

		@seeking = true
		@el.addClass 'seeking'

		@seekMove(e)

	seekMove: (e) =>
		if not @seeking then return

		@log 'Player seeking'
		targetX = e.pageX - @track.offset().left
		percent = targetX / @track.width()
		percent = Math.min(Math.max(percent, 0), 1)

		@sound.setPosition percent * @sound.duration
		@playerTimeUpdated()

	seekEnd: =>
		if not @seeking then return

		@log 'Player done seeking'
		@seeking = false
		@el.removeClass 'seeking'

		if @wasPlaying then @play()

	playerLoaded: =>
		@log 'Player loaded'

	playerPlayed: =>
		@log 'Player will play'
		@playing = true
		@el.addClass 'playing'

	playerPaused: =>
		@log 'Player will pause'
		@playing = false
		@el.removeClass 'playing'

	playerTimeUpdated: =>
		@log 'Player time updated'
		percent = (@sound.position / @sound.duration) * 100

		@seekLine.css 'left', percent + '%'
		@fill.css 'width', percent + '%'
		@thumb.css 'left', percent + '%'

	playerFinished: =>
		@log 'Player finished'
		@playerPaused()

		delay 250, =>
			@sound.setPosition 0
			@playerTimeUpdated()

exports = SonogramPlayer
