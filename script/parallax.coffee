define (require) ->
	$ = require 'jQuery'
	{delay} = require 'util'

	multiplierAttr = 'data-parallax-multiplier'
	elements = $("[#{multiplierAttr}]")

	debounceTimeout = NaN

	parallaxOnScroll = ->
		if debounceTimeout then return

		debounceTimeout = delay 33, ->
			elements.each ->
				element = $(@)
				multiplier = parseFloat(element.attr multiplierAttr)
				position = "#{-1 * scrollX * multiplier}px #{-1 * scrollY * multiplier}px"

				element.css
					'backgroundPosition': position

			debounceTimeout = NaN

	$(document).on 'scroll', parallaxOnScroll

	elements
