define (require, exports, module) ->
  Favorite = require 'zooniverse/models/Favorite'

  # TODO: This is awful.
  # Make a base and have Favorite and Recent extend it.
  class Recent extends Favorite
    @className: 'Recent'
    @instances: []

  module.exports = Recent
