define (require, exports, module) ->
  $ = require 'jQuery'

  BaseClassifier = require 'zooniverse/controllers/Classifier'

  template = require 'views/Classifier'
  tutorialSteps = require 'tutorialSteps'

  SpectrogramPlayer = require 'controllers/SpectrogramPlayer'
  FieldGuide = require 'controllers/FieldGuide'
  FrequencySelector = require 'controllers/FrequencySelector'
  Annotation = require 'zooniverse/models/Annotation'

  class Classifier extends BaseClassifier
    template: template
    tutorialStep: tutorialSteps

    player: null

    selectors: null

    events: $.extend
      'mousedown .spectrogram img': 'addFrequencyRange'
      # 'click .done': 'done'
      # 'click .followup .favorite': 'markAsFavorite'
      # 'click .followup .yes': 'goToTalk'
      # 'click .followup .no': 'nextSubject'
      BaseClassifier::events

    elements: $.extend
      '.player': 'playerContainer'
      '.questions': 'questionsContainer'
      '.field-guide': 'fieldGuideContainer'
      BaseClassifier::elements

    constructor: ->
      super

      @player = new SpectrogramPlayer el: @playerContainer
      @fieldGuide = new FieldGuide el: @fieldGuideContainer

      @selectors = []

    reset: =>
      super
      subject = @workflow.selection[0]
      @player.setImage subject.location.standard
      @player.setAudio subject.location.audio

    addFrequencyRange: (e) =>
      e.preventDefault()

      y = 1 - ((e.pageY - @playerContainer.offset().top) / @playerContainer.height())

      selector = new FrequencySelector
        classifier: @
        range: new Annotation
          classification: @classification
          value:
              low: y - 0.005
              high: y + 0.005
              times: []
        mouseDown: e

      @selectors.push selector
      selector.appendTo @player.spectrogram.parent()

  module.exports = Classifier
