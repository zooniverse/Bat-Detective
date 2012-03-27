Spine = require 'Spine'
$ = require 'jQuery'
soundManager = require 'soundManager'

AudioButton = require 'controllers/AudioButton'
translations = require 'translations'
{delay, limit} = require 'util'

PLAYER_TEMPLATE = require 'lib/text!views/SonogramPlayer.html'

class SonogramPlayer extends Spine.Controller
	subject: null

	sound: null
	playing: false
	seeking: false
	wasPlaying: false

	className: 'sonogram-player'
	template: PLAYER_TEMPLATE

	events:
		'click .controls .play': 'play'
		'click .controls .pause': 'pause'
		'click .controls .field-guide': 'toggleFieldGuide'
		'mousedown .seek': 'seekStart'

	elements:
		'.seek .track': 'track'
		'.seek .fill': 'fill'
		'.seek .thumb': 'thumb'
		'.image': 'imageContainer'
		'.image .sonogram': 'sonogram'
		'.image .seek-line': 'seekLine'
		'.controls .field-guide': 'fieldGuideButton'
		'.details .location > .value': 'location'
		'.details .environment > .value': 'environment'
		'.details .date > .value': 'date'
		'.details .time > .value': 'time'
		'.field-guide:not(button)': 'fieldGuide'

	constructor: ->
		super

		@el.html @template
		@refreshElements()

		for audioButton in @$('.field-guide [data-audio-src]')
			new AudioButton el: audioButton

		@setSubject @subject

	delegateEvents: ->
		super
		$(document).on 'mousemove', @seekMove
		$(document).on 'mouseup', @seekEnd
		$(document).on 'keydown', @onDocKeyDown

	setSubject: (@subject) =>
		@sound?.destruct()
		soundManager.onready =>
			@sound = soundManager.createSound
				id: '_' + Math.floor Math.random() * 1000
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
		@playerTimeUpdated()

	seekEnd: =>
		if not @seeking then return

		@seeking = false
		@el.removeClass 'seeking'

		if @wasPlaying then @play()

	playerLoaded: =>

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
		@playerPaused()

		delay 250, =>
			@sound.setPosition 0
			@playerTimeUpdated()

	toggleFieldGuide: =>
		@fieldGuide.add(@fieldGuideButton).toggleClass 'active'

	SPACE = 32
	LEFT = 37
	RIGHT = 39

	onDocKeyDown: (e) =>
		# Only respond if we're on the classification page.
		return if @el.parents('[data-page]:not(.active)').length isnt 0

		if e.which in [SPACE, LEFT, RIGHT] then e.preventDefault()

		if e.which is SPACE
			if @playing then @pause() else @play()
		else if e.which is LEFT
			@sound.setPosition limit @sound.position - 333, 0, @sound.duration
			@playerTimeUpdated()
		else if e.which is RIGHT
			@sound.setPosition limit @sound.position + 333, 0, @sound.duration
			@playerTimeUpdated()

exports = SonogramPlayer
