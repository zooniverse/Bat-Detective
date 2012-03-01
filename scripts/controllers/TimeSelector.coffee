Spine = require 'Spine'

TIME_TEMPLATE = require 'lib/text!views/TimeSelector.html'

class TimeSelector extends Spine.Controller
	range: null

	className: 'time-selector'
	template: TIME_TEMPLATE

	events:
		'mousedown': 'onMouseDown'
		'click .delete': 'onDeleteClick'

	elements:
		'.start.handle': 'startHandle'
		'.end.handle': 'endHandle'

	constructor: ->
		super
		@el.html @template
		@refreshElements()

		@range.bind 'change', @onRangeChange
		@range.bind 'destroy', @release
		@range.trigger 'change'

	delegateEvents: ->
		super
		$(document).on 'mousemove', @onDocMouseMove
		$(document).on 'mouseup', @onDocMouseUp

	onMouseDown: (e) => e.preventDefault(); e.stopPropagation(); @mouseDown = e
	onDocMouseMove: (e) => @onDrag e if @mouseDown
	onDocMouseUp: (e) => delete @mouseDown

	onDrag: (e) =>
		e.stopPropagation()

		target = $(@mouseDown.target)

		x = (e.pageX - @el.parent().offset().left) / @el.parent().width()

		if target.is @startHandle
			attribute = 'start'
		else if target.is @endHandle
			attribute = 'end'
		else if target.is @el
			size = @range.end - @range.start
			@range.updateAttributes
				start: x - (size / 2)
				end: x + (size / 2)
		else if @el.has(target).length is 0
			if e.pageX < @mouseDown.pageX
				attribute = 'start'
			else
				attribute = 'end'

		if attribute
			@range.updateAttribute attribute, x

	onDeleteClick: (e) =>
		e.stopPropagation()
		@range.destroy()

	onRangeChange: =>
		@el.css
			left: (@range.start * 100) + '%'
			right: ((1 - @range.end) * 100) + '%'

exports = TimeSelector
