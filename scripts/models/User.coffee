Spine = require 'Spine'

Favorite = require 'models/Favorite'

class User extends Spine.Model
  @configure 'User', 'username', 'finishedTutorial'
  @hasMany 'favorites', Favorite

  @extend Spine.Model.Local

  @current: null

  @signIn: (@current) ->
    @trigger 'change-current', @current

  @signOut: ->
    @signIn null

Favorite.belongsTo 'user', User

exports = User
