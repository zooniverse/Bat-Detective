Spine = require 'Spine'

Workflow = require 'controllers/Workflow'
workflowQuestion = require 'workflowQuestion'

TimeSelector = require 'controllers/TimeSelector'

FREQUENCY_TEMPLATE = require 'lib/text!views/FrequencySelector.html'

class FrequencySelector extends Spine.Controller
	range: null
	workflow: null

	className: 'frequency-selector'
	template: FREQUENCY_TEMPLATE

	events:
		'mousedown': 'onMouseDown'
		'mousemove': 'onMouseMove'
		'mouseup': 'onMouseUp'
		'mousedown .times': 'addTimeRange'

	elements:
		'.high.cover': 'highCover'
		'.low.cover': 'lowCover'
		'.high.cover > .handle': 'highHandle'
		'.low.cover > .handle': 'lowHandle'
		'.cover > .workflow': 'workflowContainer'
		'.times': 'timesContainer'

	constructor: ->
		super
		@el.html @template
		@refreshElements()

		@range.bind 'change', @onRangeChange
		@range.bind 'destroy', @release
		@range.trigger 'change'

		@workflow = new Workflow
			el: @workflowContainer
			model: @range
			question: workflowQuestion

	onMouseDown: (e) => e.preventDefault(); e.stopPropagation(); @mouseDown = e
	onMouseMove: (e) => @onDrag e if @mouseDown
	onMouseUp: (e) => delete @mouseDown

	onDrag: (e) =>
		target = $(@mouseDown.target)

		if target.is @highHandle
			attribute = 'high'
		else if target.is @lowHandle
			attribute = 'low'
		else if @el.has(target).length is 0
			# A target outside the FrequencySelector means it's brand new.
			# If it moves up, change the high.
			# If it moves down, change the low.
			if e.pageY < @mouseDown.pageY
				attribute = 'high'
			else
				attribute = 'low'

		if attribute
			y = 1 - ((e.pageY - @el.offset().top) / @el.height())
			@range.updateAttribute attribute, y

	onRangeChange: =>
		highHeight = ((1 - @range.high) * 100) + '%'
		lowHeight = (@range.low * 100) + '%'

		@highCover.css 'height', highHeight
		@lowCover.css 'height', lowHeight
		@timesContainer.css
			top: highHeight
			bottom: lowHeight

		workflowTarget = if highHeight > lowHeight then @highCover else @lowCover
		@workflowContainer.appendTo workflowTarget

	addTimeRange: (e) =>
		e.preventDefault()

		x = (e.pageX - @timesContainer.offset().left) / @timesContainer.width()

		@timeRange = new TimeSelector
			range: @range.timeRanges().create
				start: x - 0.005
				end: x + 0.005
			mouseDown: e

		window.range = @timeRange.range

		@timeRange.el.appendTo @timesContainer

exports = FrequencySelector
