define (require) ->
	$ = require 'jQuery'
	
	multiplierAttr = 'data-parallax-multiplier'
	elements = $("[#{multiplierAttr}]")

	debounceTimeout = NaN

	updateBackgrounds = ->
		elements.each ->
			element = $(@)
			multiplier = parseFloat(element.attr multiplierAttr)
			position = "#{-1 * scrollX * multiplier}px #{-1 * scrollY * multiplier}px"

			element.css
				'backgroundPosition': position

		debounceTimeout = NaN

	parallaxOnScroll = ->
		if debounceTimeout then return
		debounceTimeout = setTimeout updateBackgrounds, 33

	$(document).on 'scroll', parallaxOnScroll

	elements
