$ = require 'jQuery'

SonogramPlayer = require 'controllers/SonogramPlayer'
FrequencySelector = require 'controllers/FrequencySelector'

User = require 'models/User'
Subject = require 'models/Subject'

CLASSIFIER_TEMPLATE = require 'lib/text!views/SonogramClassifier.html'

class SonogramClassifier extends SonogramPlayer
  subject: null
  classification: null

  className: "#{SonogramPlayer::className} sonogram-classifier"

  template: """
    #{SonogramPlayer::template}
    #{CLASSIFIER_TEMPLATE}
  """

  events: $.extend
    'mousedown .sonogram': 'addFrequencyRange'
    'click .done': 'done'
    'click .followup .yes': 'goToTalk'
    'click .followup .no': 'nextSubject'
    SonogramPlayer::events

  elements: $.extend
    '.workflows': 'workflowContainer'
    '.continue': 'continueContainer'
    SonogramPlayer::elements

  setSubject: (@subject) =>
    selection.release() for selection in @selections or []
    @selections = []

    super

    @classification = @subject.classifications().create {}
    @continueContainer.removeClass 'active'

  addFrequencyRange: (e) =>
    e.preventDefault()

    y = 1 - (e.pageY - @sonogram.offset().top) / @sonogram.height()

    selection = new FrequencySelector
      range: @classification.frequencyRanges().create
        low: y - 0.005
        high: y + 0.005
      workflowContainer: @workflowContainer
      mouseDown: e

    selection.el.appendTo @imageContainer
    @selections.push selection

  done: =>
    selection.deselect() for selection in @selections
    @continueContainer.addClass 'active'

  goToTalk: =>
    alert 'TODO: Go to talk!'

  nextSubject: (e) =>
    @classification.save()
    User.current?.addRecent @classification

    nextSubject = Subject.next()

    if nextSubject
      @setSubject nextSubject
    else
      alert 'There are no more subjects to classify!'

exports = SonogramClassifier
