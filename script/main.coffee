define (require) ->
	$ = require 'jQuery'
	Spine = require 'Spine'

	App = require 'App'
	NestedRoute = require 'NestedRoute'
	
	parallax = require 'parallax'

	window.app = new App
		el: $('#app')

	NestedRoute.setup()
