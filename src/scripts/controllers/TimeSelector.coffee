define (require, exports, module) ->
  Spine = require 'Spine'
  $ = window.jQuery

  {clamp, remove} = require 'zooniverse/util'

  template = require 'views/TimeSelector'

  class TimeSelector extends Spine.Controller
    frequencySelector: null

    range: null
    frequencyRange: null

    className: 'time-selector'
    template: template

    events:
      'mousedown': 'onMouseDown'
      'click .delete': 'onDeleteClick'

    elements:
      '.start.handle': 'startHandle'
      '.end.handle': 'endHandle'

    constructor: ->
      super
      @html @template

      @frequencyRange.bind 'change', @onRangeChange

    delegateEvents: ->
      super
      doc = $(document)
      doc.on 'mousemove', @onDocMouseMove
      doc.on 'mouseup', @onDocMouseUp

    onMouseDown: (e) =>
      return if @frequencySelector.classifier.isDisabled()

      e.preventDefault()
      e.stopPropagation()
      @mouseDown = e
      @trigger 'select'

    onDocMouseMove: (e) =>
      @onDrag e if @mouseDown

    onDocMouseUp: (e) =>
      delete @mouseDown

    onDrag: (e) =>
      e.stopPropagation()

      target = $(@mouseDown.target)

      x = (e.pageX - @el.parent().offset().left) / @el.parent().width()

      if target.is @startHandle
        @range.start = clamp x, min: 0, max: @range.end
      else if target.is @endHandle
        @range.end = clamp x, min: @range.start, max: 1
      else if target.is @el
        size = @range.end - @range.start
        unless x - (size / 2) < 0 or x + (size / 2) > 1
          @range.start = x - (size / 2)
          @range.end = x + (size / 2)
      else if @el.has(target).length is 0
        if e.pageX < @mouseDown.pageX
          @range.start = clamp x
        else
          @range.end = clamp x

      @frequencyRange.trigger 'change'

    onDeleteClick: (e) =>
      return if @frequencySelector.classifier.isDisabled()
      e.stopPropagation()
      remove @range, from: @frequencyRange.value.times
      @release()

    onRangeChange: =>
      @el.css
        left: (@range.start * 100) + '%'
        right: ((1 - @range.end) * 100) + '%'

  module.exports = TimeSelector
