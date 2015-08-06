define (require, exports, module) ->
  Spine = require 'Spine'

  {remove} = require 'zooniverse/util'

  class Annotation extends Spine.Model
    # Belongs to a classification
    @configure 'Annotation', 'value', 'classification'

    constructor: ->
      super
      @value ?= {}

      throw new Error 'Annotation created without a classification' unless @classification?

      @bind 'change', =>
        @classification.trigger 'change'

      # NOTE: Spine seems to be running model constructors twice. Bug?
      alreadyThere = false
      for annotation in @classification.annotations
        alreadyThere ||= annotation.eql @

      @classification.annotations.push @ unless alreadyThere
      @classification.trigger 'change'

    toJSON: =>
      @value

    destroy: =>
      remove @, from: @classification.annotations
      @classification.trigger 'change'

      super

  module.exports = Annotation
