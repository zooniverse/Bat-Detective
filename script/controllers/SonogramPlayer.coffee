define (require) ->
	Spine = require 'Spine'
	$ = require 'jQuery'

	{delay} = require 'util'

	class SonogramPlayer extends Spine.Controller
		model: null

		playing: false
		seeking: false
		wasPlaying: false

		seekAt: NaN
		duration: NaN

		className: 'sound-classifier'
		random: NaN

		template: """
			<div class="jplayer"></div>

			<div class="controls">
				<button class="play">Play</button>
				<button class="pause">Pause</button>

				<div class="seek">
					<div class="track">
						<div class="fill"></div>
						<div class="thumb"></div>
					</div>
				</div>
			</div>

			<div class="image">
				<div class="seek-line"></div>
				<img src="" class="sonogram" />
			</div>

			<div class="description">
				<div class="location"></div>
				<div class="environment"></div>
				<div class="date"></div>
				<div class="time"></div>
			</div>

			<div class="action">
				<button class="clear">Clear</button>
				<button class="done">Done</button>
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
			'.description > .location': 'location'
			'.description > .environment': 'environment'
			'.description > .date': 'date'
			'.description > .time': 'time'

		constructor: ->
			super

			# Use this to identify the controller's node from jPlayer
			@random = Math.floor Math.random() * 1000
			@el.attr 'data-random', @random

			@el.html @template
			@refreshElements()

			# Set up the jPlayer instance
			@player
				swfPath: '/lib/jPlayer'
				supplied: 'm4a, oga'
				volume: 1

				ready: @playerReady
				play: @playerPlayed
				timeupdate: @playerTimeUpdated # Fires during play
				pause: @playerPaused

		delegateEvents: ->
			super
			$(document).on 'mouseup', @seekEnd

		setModel: (@model) =>
			# Sometimes the image never loads unless we wait a tick to load the audio
			delay 0, =>
				@player 'setMedia',
					mp3: @model.mp3
					oga: @model.oga

			@sonogram.attr 'src', @model.image

			@location.html @model.location
			@environment.html @model.environment

		play: =>
			@player 'play', (@seekAt / 100) * @duration

		pause: =>
			@player 'pause'

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
			percent = (targetX / @track.width()) * 100

			@player 'playHead', percent

		seekEnd: (e) =>
			@seeking = false
			@el.removeClass 'seeking'

			if @wasPlaying then @play()

		# Convenience alias for the jPlayer instance
		player: (args...) =>
			@playerElement.jPlayer args...

		playerReady: (e) =>
			if @model then @setModel @model
			@log 'Created new SoundPlayer', @

		playerPlayed: (e) =>
			@playing = true
			@el.addClass 'playing'

		playerPaused: (e) =>
			@playing = false
			@el.removeClass 'playing'

		playerTimeUpdated: (e) =>
			@duration = e.jPlayer.status.duration
			@seekAt = e.jPlayer.status.currentPercentRelative

			@seekLine.css 'left', @seekAt + '%'
			@fill.css 'width', @seekAt + '%'
			@thumb.css 'left', @seekAt + '%'
