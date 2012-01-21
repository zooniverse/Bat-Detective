define (require) ->
	Spine = require 'Spine'

	class Page extends Spine.Controller
		activate: =>
			@el.addClass 'active'
			@el.removeClass 'before'
			@el.removeClass 'after'

		deactivate: (inactiveClass) =>
			@el.removeClass 'active'
			if inactiveClass then @el.addClass inactiveClass

		before: =>
			@deactivate 'before'

		after: =>
			@deactivate 'after'
