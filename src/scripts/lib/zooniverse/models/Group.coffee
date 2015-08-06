define (require, exports, module) ->
  Spine = require 'Spine'

  class Group extends Spine.Model
    @configure 'Group'

  module.exports = Group
