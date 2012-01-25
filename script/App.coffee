define (require) ->
	Spine = require 'Spine'
	Pager = require 'Pager'
	SonogramClassifier = require 'SonogramClassifier'

	class App extends Spine.Controller
		pagers: null
		classifier: null

		constructor: ->
			super

			@pagers = @$('[data-page]').parent().map ->
				new Pager
					el: @

			@classifier = new SonogramClassifier
				el: @$('#sound-classifier')
