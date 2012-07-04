define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  {remove} = require 'zooniverse/util'

  template = require 'views/TimeSelector'

  class TimeSelector extends Spine.Controller
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
        @range.start = x
      else if target.is @endHandle
        @range.end = x
      else if target.is @el
        size = @range.end - @range.start
        @range.start = x - (size / 2)
        @range.end = x + (size / 2)
      else if @el.has(target).length is 0
        if e.pageX < @mouseDown.pageX
          @range.start = x
        else
          @range.end = x

      @frequencyRange.trigger 'change'

    onDeleteClick: (e) =>
      e.stopPropagation()
      remove @range, from: @frequencyRange.value.times
      @release()

    onRangeChange: =>
      @el.css
        left: (@range.start * 100) + '%'
        right: ((1 - @range.end) * 100) + '%'

  module.exports = TimeSelector
