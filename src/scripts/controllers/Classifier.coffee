define (require, exports, module) ->
  $ = require 'jQuery'

  BaseClassifier = require 'zooniverse/controllers/Classifier'

  template = require 'views/Classifier'
  tutorialSteps = require 'tutorialSteps'

  FieldGuide = require 'controllers/FieldGuide'

  class Classifier extends BaseClassifier
    template: template
    tutorialStep: tutorialSteps

    events: $.extend
      'click .example': -> alert 'Example clicked'
      BaseClassifier::events

    elements: $.extend
      '.example': 'exampleNode'
      BaseClassifier::elements

    constructor: ->
      super

      @fieldGuide = new FieldGuide
      @append @fieldGuide

  module.exports = Classifier
