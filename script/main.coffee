define (require) ->
	$ = require 'jQuery'
	Spine = require 'Spine'
	App = require 'App'
	NestedRoute = require 'NestedRoute'

	window.app = new App
		el: $('#app')

	NestedRoute.setup()
