define (require, exports, module) ->
  {Step} = require 'zooniverse/controllers/Tutorial'

  module.exports = [
    new Step
      content: ['Tutorial']
      attach: to: '[data-page="classify"]'
  ]
