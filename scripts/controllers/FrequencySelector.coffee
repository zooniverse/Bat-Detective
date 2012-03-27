Spine = require 'Spine'

Workflow = require 'controllers/Workflow'
workflowQuestion = require 'workflowQuestion'

TimeSelector = require 'controllers/TimeSelector'

FREQUENCY_TEMPLATE = require 'lib/text!views/FrequencySelector.html'

class FrequencySelector extends Spine.Controller
	range: null
	workflowContainer: null

	workflow: null

	className: 'frequency-selector'
	template: FREQUENCY_TEMPLATE

	events:
		'mousedown': 'onMouseDown'
		'mousemove': 'onMouseMove'
		'mouseup': 'onMouseUp'
		'mousedown .times': 'onTimesMouseDown'
		'click .delete': 'onDeleteClick'

	elements:
		'.high.cover': 'highCover'
		'.low.cover': 'lowCover'
		'.high.cover > .handle': 'highHandle'
		'.low.cover > .handle': 'lowHandle'
		'.times': 'timesContainer'

	constructor: ->
		super
		@el.html @template
		@refreshElements()

		@range.bind 'change', @onRangeChange
		@range.bind 'destroy', @release
		@range.trigger 'change'

		console.log @workflowContainer

		@workflow = new Workflow
			model: @range
			question: workflowQuestion

		@workflow.el.appendTo @workflowContainer

		@select()
		@range.bind 'finish', @deselect

	onMouseDown: (e) =>
		e.preventDefault()
		e.stopPropagation()
		@mouseDown = e

	onMouseMove: (e) =>
		@onDrag e if @mouseDown

	onMouseUp: (e) =>
		delete @mouseDown

	onDrag: (e) =>
		target = $(@mouseDown.target)

		if target.is @highHandle
			attribute = 'high'
		else if target.is @lowHandle
			attribute = 'low'
		else if @el.has(target).length is 0
			# A target outside the FrequencySelector means it's brand new.
			# If it moves up, change the high. If it moves down, change the low.
			attribute = if e.pageY < @mouseDown.pageY then 'high' else 'low'

		if attribute
			y = 1 - ((e.pageY - @el.offset().top) / @el.height())
			@range.updateAttribute attribute, y

	onRangeChange: =>
		@el.attr 'data-source', @range.source

		highHeight = (1 - @range.high) * 100
		lowHeight = @range.low * 100

		@highCover.css 'height', highHeight + '%'
		@lowCover.css 'height', lowHeight + '%'
		@timesContainer.css
			top: highHeight + '%'
			bottom: lowHeight + '%'

	onTimesMouseDown: (e) =>
		e.preventDefault()
		x = (e.pageX - @timesContainer.offset().left) / @timesContainer.width()

		@addTimeRange x - 0.005, x + 0.005, e

	addTimeRange: (start, end, mouseDown) =>
		timeRange = new TimeSelector
			range: @range.timeRanges().create
				start: start
				end: end
			mouseDown: mouseDown

		timeRange.bind 'select', @select
		timeRange.el.appendTo @timesContainer

	select: =>
		@el.addClass 'active'
		@workflow.select()

	deselect: =>
		# If there are no time range selections,
		# assume the whole thing should be selected.
		if @range.timeRanges().all().length is 0
			@addTimeRange 0, 1

		@el.removeClass 'active'
		@workflow.deselect()

	onDeleteClick: (e) =>
		e.stopPropagation()
		@range.destroy()

exports = FrequencySelector
