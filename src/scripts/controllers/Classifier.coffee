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
      'click .next-subject': 'showSummary'
      'click .summary .favorite .create button': 'createFavorite'
      'click .summary .favorite .destroy button': 'createFavorite'
      'click .summary .talk .yes': 'goToTalk'
      'click .summary .talk .no': 'nextSubjects'
      BaseClassifier::events

    elements: $.extend
      '.scale': 'scale'
      '.player': 'playerContainer'
      '.decision-tree': 'decisionTreeContainer'
      '.field-guide': 'fieldGuideContainer'
      BaseClassifier::elements

    constructor: ->
      super

      @player = new SpectrogramPlayer el: @playerContainer
      @scale.insertBefore @player.spectrogram

      @fieldGuide = new FieldGuide el: @fieldGuideContainer

      @selectors = []

    reset: =>
      super
      @el.removeClass 'showing-summary'
      subject = @workflow.selection[0]
      @player.setImage subject.location.image
      @player.setAudio subject.location.audio

    addFrequencyRange: (e) =>
      e.preventDefault()

      y = 1 - ((e.pageY - @player.spectrogram.offset().top) / @player.spectrogram.height())

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

    showSummary: =>
      selector.deselect for selector in @selectors
      @saveClassification()
      @el.addClass 'showing-summary'

  module.exports = Classifier
