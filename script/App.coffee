define (require) ->
	Spine = require 'Spine'
	Pager = require 'Pager'

	class App extends Spine.Controller
		pagers: null

		constructor: ->
			super

			@pagers = @$('[data-page]').parent().map ->
				new Pager
					el: @
