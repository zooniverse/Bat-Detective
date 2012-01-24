define (require) ->
	Spine = require 'Spine'
	$ = require 'jQuery'

	class SoundClassifier extends Spine.Controller
		player: null

		audioSrc: ''
		imgSrc: '/example-data/sonogram.jpg'

		random: NaN

		constructor: ->
			super

			@el.addClass 'sound-classifier'

			# Use this to identify the controller's node from jPlayer
			@random = Math.floor Math.random() * 1000
			@el.attr 'data-random', @random

			@el.html """
				<div class="jplayer"></div>

				<div class="jp-gui">
					<button class="jp-play">Play</button>
					<button class="jp-pause">Pause</button>

					<div class="progress">
						<div class="jp-seek-bar">
							<div class="jp-play-bar">
								<div class="fill"></div>
								<div class="line"></div>
								<div class="thumb"></div>
							</div>
						</div>
					</div>

					<div class="jp-no-solution">
						<p>To play this media you will need to either
						update your browser to a more recent version
						or update your Adobe Flash plugin.</p>
					</div>
				</div>

				<img src="#{@imgSrc}" />
			"""

			# Set up the jPlayer instance
			@player
				swfPath: '/lib/jPlayer'
				supplied: 'm4a, oga'
				cssSelectorAncestor: "[data-random='#{@random}']"

				ready: (e) =>
					@player 'setMedia'
						m4a: '/example-data/cro-magnon-man.m4a'
						oga: '/example-data/cro-magnon-man.oga'

					@log 'Created new Classifier', @

		# Convenience alias for jPlayer
		player: (args...) =>
			@el.children('.jplayer').jPlayer(args...)
