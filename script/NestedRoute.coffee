define (require) ->
	Spine = require 'Spine'

	# This totally sucks,
	# but there's no way to extend this so that the context
	# of the original methods is the extended class.

	Spine.Route.superMatchRoute = Spine.Route.matchRoute

	Spine.Route.matchRoute = (path, options) ->
		if typeof path is 'string'			
			path = path.split('/')

		matchPath = []
		while path.length > 0
			matchPath.push path.shift()
			@superMatchRoute matchPath.join '/'

	Spine.Route
