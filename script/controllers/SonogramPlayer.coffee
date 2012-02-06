define (require) ->
	Spine = require 'Spine'
	$ = require 'jQuery'
	soundManager = require 'soundManager'

	translations = require 'translations'
	{delay} = require 'util'

	class SonogramPlayer extends Spine.Controller
		model: null

		playing: false
		seeking: false
		wasPlaying: false

		className: 'sound-classifier'
		template: """
			<div class="image">
				<div class="axis">
					<div class="space">
						<div class="label">200 KHz</div>
					</div>
					<div class="space"></div>
					<div class="space"></div>
					<div class="space"></div>
					<div class="space"></div>
					<div class="space"></div>
					<div class="space">
						<div class="label">100 KHz</div>
					</div>
					<div class="space"></div>
					<div class="space"></div>
					<div class="space"></div>
					<div class="space"></div>
					<div class="space"></div>
				</div>

				<img src="" class="sonogram" />

				<div class="seek-line"></div>
			</div>

			<div class="seek">
				<div class="track">
					<div class="fill"></div>
					<div class="thumb"></div>
				</div>
			</div>

			<div class="controls">
				<button class="play">Play</button>
				<button class="pause">Pause</button>

				<div class="details">
					<div class="location field">
						<span class="value"></span>
					</div>
					
					<div class="environment field">
						<span class="value"></span>
					</div>

					<div class="date field">
						<span class="value"></span>
					</div>

					<div class="time field">
						<span class="value"></span>
					</div>
				</div>

				<div class="actions">
					<button class="clear">Clear</button>
					<button class="done">Done</button>
				</div>
			</div>
		"""

		events:
			'click .play': 'play'
			'click .pause': 'pause'
			'mousedown .seek': 'seekStart'
			'mousemove .seek': 'seekMove'

		elements:
			'.jplayer': 'playerElement'
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

			# Use this to identify the controller's node from jPlayer
			@random = Math.floor Math.random() * 1000
			@el.attr 'data-random', @random

			@el.html @template
			@refreshElements()

		delegateEvents: ->
			super
			$(document).on 'mouseup', @seekEnd

		setModel: (@model) =>
			soundManager.onready =>
				@sound?.destruct()
				@sound = soundManager.createSound
					id: @model.id or '_' + Math.floor Math.random() * 1000
					url: @model.url

					autoload: true
					onload: @playerFinished
					onplay: @playerPlayed
					onpause: @playerPaused
					whileplaying: @playerTimeUpdated
					onfinish: @playerFinished
				
			@sonogram.attr 'src', @model.image

			@location.html @model.location
			@environment.html @model.environment

			dt = new Date @model.datetime

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

			@sound.setPosition percent * @sound.duration

		seekEnd: (e) =>
			@seeking = false
			@el.removeClass 'seeking'

			if @wasPlaying then @play()

		playerPlayed: (e) =>
			@playing = true
			@el.addClass 'playing'

		playerPaused: (e) =>
			@playing = false
			@el.removeClass 'playing'

		playerTimeUpdated: (e) =>
			percent = (@sound.position / @sound.duration) * 100

			@seekLine.css 'left', percent + '%'
			@fill.css 'width', percent + '%'
			@thumb.css 'left', percent + '%'

		playerFinished: =>
			# We always want the sound to be "playing", even when it's paused,
			# so that the whileplaying callback fires as we seek.
			@sound.play()
			@sound.pause()
