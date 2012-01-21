define (require) ->
	Spine = require 'Spine'
	$ = require 'jQuery'
	Page = require 'Page'

	class window.Pager extends Spine.Controller
		path: ''
		pages: null
		tabs: null

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

			@pages ||= do =>
				@el.children('[data-page]').map ->
					new Page
						el: @

			@tabs ||= []

			@route @path, @pathMatched

			console.log "Created new Pager at \"#{@path}\" " +
			"with #{@pages.length} pages and #{@tabs.length} tabs"

		pathMatched: (params) =>
			matched = false

			@pages.each ->
				if @el.attr('data-page') == params.page
					matched = true
					@activate()
				else
					if not matched
						@before()
					else
						@after()
