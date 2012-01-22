define (require) ->
	Spine = require 'Spine'
	$ = jQuery

	class Page extends Spine.Controller
		path: '' # Like "/foo/bar"
		
		tabs: null

		constructor: ->
			super

			@tabs ||= $("a[href='##{@path}']")

			if @el.hasClass 'active' then @activate()

			@log "New Page at \"#{@path}\" and #{@tabs.length} tabs"

		activate: =>
			elAndTabs = @el.add @tabs
			elAndTabs.addClass 'active'
			elAndTabs.removeClass 'before'
			elAndTabs.removeClass 'after'

		deactivate: (inactiveClass) =>
			elAndTabs = @el.add @tabs
			elAndTabs.removeClass 'active'
			elAndTabs.addClass inactiveClass
