Spine = require 'Spine'

TIME_TEMPLATE = require 'lib/text!views/TimeSelector.html'

class TimeSelector extends Spine.Controller
	range: null

	className: 'time-selector'
	template: TIME_TEMPLATE

	elements:
		'.start.handle': 'startHandle'
		'.end.handle': 'endHandle'

	constructor: ->
		super
		@el.html @template
		@refreshElements()

		@range.bind 'change', @onRangeChange
		@range.trigger 'change'

	onMouseDown: (e) => e.preventDefault(); @mouseDown = e
	onMouseMove: (e) => @onDrag e if @mouseDown
	onMouseUp: (e) => delete @mouseDown

	onDrag: (e) =>
		target = $(@mouseDown.target)

		@log target

		if target.is @startHandle
			attribute = 'start'
		else if target.is @endHandle
			attribute = 'end'
		else if target is @el
			@log 'MOVE'

		if attribute
			x = (e.pageX - @el.parent().offset().left) / @el.parent().width()
			@range.updateAttribute attribute, y

	onRangeChange: =>
		@el.css
			left: (@range.start * 100) + '%'
			right: ((1 - @range.end) * 100) + '%'

exports = TimeSelector
