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
      @constructor::events

    elements: $.extend
      '.example': 'exampleNode'
      @constructor::elements

    constructor: ->
      super
      @html @template

  module.exports = Classifier
