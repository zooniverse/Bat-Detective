define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  {clamp} = require 'zooniverse/util'

  Decision = require 'controllers/Decision'
  decisionTree = require 'decisionTree'
  TimeSelector = require 'controllers/TimeSelector'

  template = require 'views/FrequencySelector'

  class FrequencySelector extends Spine.Controller
    range: null # An annotation
    classifier: null

    decision: null

    className: 'frequency-selector'
    template: template

    events:
      'mousedown': 'onMouseDown'
      'click .delete': 'onDeleteClick'

    elements:
      '.high.cover': 'highCover'
      '.low.cover': 'lowCover'
      '.times': 'timesContainer'
      '.high.cover > .handle': 'highHandle'
      '.low.cover > .handle': 'lowHandle'
      '.times > .handle': 'timesHandle'

    constructor: ->
      super
      @html @template

      @range.bind 'change', @onRangeChange
      @range.bind 'destroy', @release
      @range.trigger 'change'

      @decision = new Decision
        question: decisionTree
        annotation: @range

      @decision.appendTo @classifier.decisionTreeContainer

      @bind 'release', ->
        @decision.release()

      @select()

      @range.bind 'finish', @deselect

    delegateEvents: =>
      super
      doc = $(document)
      doc.on 'mousemove', @onDocMouseMove
      doc.on 'mouseup', @onDocMouseUp

    onMouseDown: (e) =>
      e.preventDefault()
      e.stopPropagation()
      @mouseDown = e

      @onTimesMouseDown e if $(e.target).is @timesContainer

    onDocMouseMove: (e) =>
      @onDrag e if @mouseDown

    onDocMouseUp: (e) =>
      delete @mouseDown

    onDrag: (e) =>
      target = $(@mouseDown.target)

      y = 1 - ((e.pageY - @el.offset().top) / @el.height())

      if target.is @highHandle
        @range.value.high = y
      else if target.is @lowHandle
        @range.value.low = y
      else if target.is @timesHandle
        half = (@range.value.high - @range.value.low) / 2
        @range.value.low = y - half
        @range.value.high = y + half
      else if @el.has(target).length is 0
        # A target outside the FrequencySelector means it's brand new.
        # If it moves up, change the high. If it moves down, change the low.
        if e.pageY < @mouseDown.pageY
          @range.value.high = y
        else
          @range.value.low = y

      @range.value.low = clamp @range.value.low
      @range.value.high = clamp @range.value.high

      @range.trigger 'change'

    onRangeChange: =>
      @el.attr 'data-source', @range.value.source

      highHeight = (1 - @range.value.high) * 100
      lowHeight = @range.value.low * 100

      @highCover.css 'height', highHeight + '%'
      @lowCover.css 'height', lowHeight + '%'
      @timesContainer.css
        top: highHeight + '%'
        bottom: lowHeight + '%'

    onTimesMouseDown: (e) =>
      return if $(e.target).is @timesHandle

      x = (e.pageX - @timesContainer.offset().left) / @timesContainer.width()
      @addTimeRange x - 0.005, x + 0.005, e

      @onDocMouseUp()

    addTimeRange: (start, end, mouseDown) =>
      timeSelector = new TimeSelector
        range: {start, end}
        frequencyRange: @range
        mouseDown: mouseDown

      @range.value.times.push timeSelector.range
      timeSelector.bind 'select', @select
      timeSelector.el.appendTo @timesContainer

      @range.trigger 'change'

    select: =>
      @el.addClass 'selected'
      @decision.select()
      @classifier.decisionTreeContainer.addClass 'has-selection'

    deselect: =>
      # If there are no time range selections, assume the whole thing should be selected.
      @addTimeRange 0, 1 if @range.value.times.length is 0

      @el.removeClass 'selected'
      @decision.deselect()
      @classifier.decisionTreeContainer.removeClass 'has-selection'

    onDeleteClick: (e) =>
      e.stopPropagation()
      @deselect()
      @range.destroy()

  module.exports = FrequencySelector
