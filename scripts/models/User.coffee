Spine = require 'Spine'

class User extends Spine.Model
  @configure 'User', 'username', 'finishedTutorial'
  @extend Spine.Model.Local

  @current: null

  @signIn: (@current) ->
    @trigger 'change-current', @current

  @signOut: ->
    @signIn null

exports = User
