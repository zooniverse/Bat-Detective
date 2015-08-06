define (require, exports, module) ->
  $ = require 'jQuery'
  {delay} = require 'zooniverse/util'

  User = require 'zooniverse/models/User'

  class Tutorial
    target: null
    steps: null

    skipText: '&rarr;'
    skipTitle: 'Skip this step'
    exitText: '&times;'
    exitTitle: 'Exit tutorial'

    className: 'tutorial-step'
    controlsClass: 'controls'
    arrowClass: 'arrow'
    messageClass: 'message'
    continueClass: 'continue'
    blockerClass: 'tutorial-blocker'

    el: null
    message: null
    arrow: null
    blockers: null

    current: -1

    constructor: ({@target, @steps}) ->
      @steps ?= []

      @el = $("<div class='#{@className}'></div>")
      @el.css display: 'none'

      @controls = $("""
        <div class="#{@controlsClass}">
          <button value="skip" title="#{@skipTitle}">#{@skipText}</button>
          <button value="end" title="#{@exitTitle}">#{@exitText}</button>
        </div>
      """)

      @message = $("<div class='#{@messageClass}'></div>")

      @arrow = $("<div class='#{@arrowClass}'></div>")

      @controls.appendTo @el
      @message.appendTo @el
      @arrow.appendTo @el

      @controls.on 'click', '[value="skip"]', @next
      @controls.on 'click', '[value="end"]', @end

      @el.appendTo $(@target || 'body')

      isInactive = (i, element) ->
        element = $(element)
        not element.hasClass 'active'

    probablyVisible: =>
      parentPages = @target.parents '[data-page]'
      inactiveParentPages = (el for el in parentPages when not $(el).hasClass 'active')

      inactiveParentPages.length is 0 and @current < @steps.length

    start: =>
      @steps[@current]?.leave()

      @el.css display: ''
      @current = -1
      @next()

    next: (e) =>
      @steps[@current]?.leave()

      @current += 1
      if @steps[@current]
        @steps[@current].enter @
      else
        @end()

    end: =>
      @steps[@current]?.leave()
      @current = @steps.length
      @el.css display: 'none'


  class Tutorial.Step
    heading: ''
    content: ''
    style: null
    attach: null
    block: ''
    nextOn: null
    continueText: 'Continue'
    className: ''
    arrowClass: ''
    delay: 0

    tutorial: null

    constructor: (params = {}) ->
      @[property] = value for own property, value of params

      @content = [@content] if typeof @content is 'string'
      @content = $(("<p>#{line}</p>" for line in @content).join '') if @content instanceof Array
      @content = $("<p class='heading'>#{@heading}</p>").add @content if @heading

      @attach ?= {}
      @attach.x ?= 'center'
      @attach.y ?= 'middle'
      @attach.to ?= ''
      @attach.at ?= {}
      @attach.at.x ?= 'center'
      @attach.at.y ?= 'middle'

    enter: (@tutorial) =>
      @onEnter.call @, @tutorial
      @tutorial.message.html @content

      if @nextOn?
        $(document).on eventName, selector, @tutorial.next for eventName, selector of @nextOn
      else
        buttonsHolder = $("<div class='#{@tutorial.continueClass}'><button>#{@continueText}</button></div>")
        @tutorial.message.append buttonsHolder
        @tutorial.el.on 'click', ".#{@tutorial.continueClass} button", @tutorial.next

      @tutorial.el.css @style if @style
      @tutorial.arrow.addClass @arrowClass if @arrowClass

      delay @delay, =>
        @moveMessage()
        @createBlockers()

      @tutorial.el.addClass @className if @className

    onEnter: =>
      # Override this.

    moveMessage: () ->
      xStrings = left: 0, center: 0.5, right: 1
      yStrings = top: 0, middle: 0.5, bottom: 1

      @attach.x = xStrings[@attach.x] if @attach.x of xStrings
      @attach.y = yStrings[@attach.y] if @attach.y of yStrings
      @attach.at.x = xStrings[@attach.at.x] if @attach.at.x of xStrings
      @attach.at.y = yStrings[@attach.at.y] if @attach.at.y of yStrings

      target = $(@attach.to).filter(':visible').first()

      targetSize = width: target.outerWidth(), height: target.outerHeight()
      targetOffset = target.offset()

      stepSize = width: @tutorial.el.outerWidth(), height: @tutorial.el.outerHeight()
      stepOffset =
        left: targetOffset.left - (stepSize.width * @attach.x) + (targetSize.width * @attach.at.x)
        top: targetOffset.top - (stepSize.height * @attach.y) + (targetSize.height * @attach.at.y)

      @tutorial.el.css position: 'absolute'
      @tutorial.el.offset stepOffset

    createBlockers: =>
      @tutorial.blockers = $()

      for element in $(@block)
        element = $(element)
        blocker = $("<div class='#{@tutorial.blockerClass}'></div>")
        blocker.insertAfter @tutorial.el
        @tutorial.blockers = @tutorial.blockers.add blocker

        blocker.css position: 'absolute'
        blocker.width element.outerWidth()
        blocker.height element.outerHeight()
        blocker.offset element.offset()

    leave: =>
      @onLeave.call @, @tutorial
      @tutorial.message.html ''

      if @nextOn?
        $(document).off eventName, selector, @tutorial.next for eventName, selector of @nextOn
      else
        @tutorial.el.off 'click', ".#{@tutorial.continueClass} button", @tutorial.next

      @tutorial.arrow.removeClass @arrowClass if @arrowClass
      @tutorial.el.removeClass @className if @className

      @tutorial.blockers.remove().empty()

    onLeave: =>
      # Override this.

  module.exports = Tutorial
