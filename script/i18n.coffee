define (require, exports) ->
	$ = require 'jQuery'
	translations = require 'translations'

	defaultLocale = 'en'

	get = (root = document.body, locale = defaultLocale) ->
		elements = $('[data-string]', root)
		if $(root).attr 'data-string' then elements.push root

		elements.each ->
			stringId = $(@).attr 'data-string'

			# The top level keys of the "strings" file are CSS selectors.
			# Check to see if this element is a child of each selector.
			for selector, strings of translations
				if not $(@).is "#{selector} *" then continue

				translation = strings[stringId][locale]
				translation ||= strings[stringId][defaultLocale]

				$(@).html translation

	translate = (tag..., translations) ->
		# The tag is optional, which is weird because it's the first arg,
		# but it makes sense when you write it. Defaults to "span".
		tag = tag.join('') || 'span'

		markup = ''

		for lang, string of translations
			markup += "<#{tag} lang=\"#{lang}\">#{string}</#{tag}>"

		# Generate an element list from the markup.
		$(markup)
