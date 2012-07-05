define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  class Decision extends Spine.Controller
    class @Question
      constructor: (@question, @answers...) ->

    class @Answer
      constructor: (@answer, @attributes, @next) ->

    annotation: null
    question: null

    path: null

    className: 'decision'

    events:
      'click .back': 'goBack'
      'click .answer': 'onAnswerClick'

    constructor: ->
      super
      @path = []

      @setQuestion @question

    setQuestion: (@question) =>
      @path.push @question

      @el.empty()
      if @path.length > 1 then @el.append '<button class="back"><span class="icon">&#9664;</span> Previous question</button>'

      @el.append "<div class=\"question\">#{@question.question}</div>"

      @answersContainer = @$('<div class="answers"></div>')
      @answersContainer.appendTo @el
      for answer, i in @question.answers
        @answersContainer.append "<button data-index=\"#{i}\" class=\"answer\">#{answer.answer}</button>"

    goBack: =>
      @path.pop()
      @setQuestion @path.pop()

    onAnswerClick: (e) =>
      answer = @question.answers[$(e.target).data 'index']

      for property, value of answer.attributes
        @annotation.value[property] = value
        @annotation.trigger 'change'

      if answer.next instanceof @constructor.Question
        @setQuestion answer.next
      else if typeof answer.next is 'function'
        answer.next.call @

    select: =>
      @el.addClass 'selected'

    deselect: =>
      @el.removeClass 'selected'

  module.exports = Decision
