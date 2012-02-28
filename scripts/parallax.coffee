$ = require 'jQuery'
{delay} = require 'util'

multiplierAttr = 'data-parallax-multiplier'
elements = $("[#{multiplierAttr}]")

debounceTimeout = NaN

parallaxOnScroll = ->
	if debounceTimeout then return

	debounceTimeout = delay 15, ->
		elements.each ->
			element = $(@)
			multiplierString = element.attr multiplierAttr

			multiplierValue = parseFloat multiplierString

			positions = element.css('backgroundPosition').split(' ')

			changeX = !!~multiplierString.toLowerCase().indexOf 'x'
			newX = "#{-1 * pageXOffset * multiplierValue}px"
			if changeX then positions[0] = newX

			changeY = !!~multiplierString.toLowerCase().indexOf 'y'
			newY = "#{-1 * pageYOffset * multiplierValue}px"
			if changeY then positions[1] = newY

			element.css
				'backgroundPosition': positions.join ' '

		debounceTimeout = NaN

$(document).on 'scroll', parallaxOnScroll

exports = elements
