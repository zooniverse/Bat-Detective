define (require, exports, module) ->
  BaseClassifier = require 'zooniverse/controllers/Classifier'
  $ = require 'jQuery'

  template = require 'views/Classifier'
  tutorialSteps = require 'tutorialSteps'

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

  module.exports = Classifier
