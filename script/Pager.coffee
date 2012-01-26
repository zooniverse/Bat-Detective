define (require) ->
	Spine = require 'Spine'
	$ = require 'jQuery'

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

	class Pager extends Spine.Controller
		path: '' # "/foo/bar/:page"

		pages: null

		constructor: ->
			super

			@path ||= do =>
				name = @el.attr 'data-page'
				segments = []

				if name then segments.push name

				@el.parents('[data-page]').each ->
					segments.unshift $(@).attr 'data-page'

				segments.push ':page'

				'/' + segments.join '/'

			path = @path

			@pages ||= do =>
				@el.children('[data-page]').map ->
					new Page
						el: @
						path: path.replace(':page', $(@).attr 'data-page')

			@route @path, @pathMatched

			@log "Created new Pager at \"#{@path}\" with #{@pages.length} pages"

		pathMatched: (params) =>
			matched = false

			@pages.each ->
				if @el.attr('data-page') == params.page
					matched = true
					@activate()
				else
					if not matched
						@deactivate 'before'
					else
						@deactivate 'after'
