define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'
  {delay} = require 'zooniverse/util'

  TEMPLATE = require 'zooniverse/views/Dialog'

  class Button extends Spine.Controller
    label: 'OK'
    value: null

    deferred: null

    tag: 'button'
    className: 'dialog-button'

    events: click: 'onClick'

    constructor: ->
      super
      @el.html @label
      @el.val @value

    onClick: =>
      @deferred.resolve @value

  class Dialog extends Spine.Controller
    content: 'Alert!'
    buttons: null
    target: 'body'

    promise: null

    className: 'dialog'
    template: TEMPLATE

    blockers: null

    elements:
      '.content': 'contentContainer'
      '.buttons': 'buttonsContainer'

    constructor: ->
      super
      @buttons ?= [{'OK': true}]
      @target = $(@target).first() unless @target instanceof $

      deferred = new $.Deferred
      @promise = deferred.promise()
      @promise.done (args...) =>
        @done? args...
        @close()

      # Convert {key: value} buttons descriptions to instances of Button
      for button, i in @buttons then for label, value of button
        @buttons[i] = new Button {label, value, deferred}

      @render()
      @el.add(@blocker).appendTo 'body'
      @reposition()
      @el.add(@blocker).addClass 'open'

    render: =>
      @html @template
      @contentContainer.html @content
      button.el.appendTo @buttonsContainer for button in @buttons

      # Apply the default class name even if we override it
      @el.addClass @constructor::className

      @blocker = $('<div class="dialog-blocker"></div>')

    reposition: ->
      size = width: @el.outerWidth(), height: @el.outerHeight()
      targetSize = width: @target.outerWidth(), height: @target.outerHeight()
      targetOffset = @target.offset()

      @el.offset
        left: targetOffset.left + (targetSize.width / 2) - (size.width / 2)
        top: targetOffset.top + (targetSize.height/ 2) - (size.height / 2)

      @blocker.width targetSize.width
      @blocker.height targetSize.height
      @blocker.offset targetOffset

    close: =>
      @el.add(@blocker).removeClass 'open'
      delay 500, =>
        @blocker.remove()
        button.release() for button in @buttons
        @release()

  module.exports = Dialog
