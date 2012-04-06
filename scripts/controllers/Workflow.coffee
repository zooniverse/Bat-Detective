Spine = require 'Spine'

class Question
	constructor: (@question, @answers...) ->

class Answer
	constructor: (@answer, @attributes, @next) ->

class Workflow extends Spine.Controller
	@Question: Question
	@Answer: Answer

	model: null
	question: null
	path: null

	className: 'workflow'

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
		if @path.length > 1 then @el.append '<button class="back">Back</button>'

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

		@model.updateAttributes answer.attributes

		if answer.next instanceof Workflow.Question
			@setQuestion answer.next
		else if answer.next instanceof Function
			answer.next.call @

	select: =>
		@el.addClass 'selected'

	deselect: =>
		@el.removeClass 'selected'

exports = Workflow
