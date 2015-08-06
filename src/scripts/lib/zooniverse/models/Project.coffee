define (require, exports, module) ->
  Spine = require 'Spine'

  class Project
    id: ''

    constructor: (params = {}) ->
      @[property] = value for own property, value of params

      @workflows ?= []
      @workflows = [@workflows] unless @workflows instanceof Array
      workflow.project = @ for workflow in @workflows

  module.exports = Project
