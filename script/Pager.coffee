define (require) ->
	Spine = require 'Spine'
	$ = require 'jQuery'
	Page = require 'Page'

	class window.Pager extends Spine.Controller
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
