define (require) ->
	Spine = require 'Spine'
	Pager = require 'Pager'
	SoundClassifier = require 'SoundClassifier'

	class App extends Spine.Controller
		pagers: null
		classifier: null

		constructor: ->
			super

			@pagers = @$('[data-page]').parent().map ->
				new Pager
					el: @

			@classifier = new SoundClassifier
				el: @$('#sound-classifier')
