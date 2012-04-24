Spine = require 'Spine'

Recent = require 'models/Recent'
Favorite = require 'models/Favorite'
Classification = require 'models/Classification'

class User extends Spine.Model
  @configure 'User', 'username', 'finishedTutorial'
  @hasMany 'recents', Recent
  @hasMany 'favorites', Favorite
  @hasMany 'classifications', Classification

  @current: null

  @signIn: (@current) ->
    @trigger 'sign-in', @current

  @signOut: ->
    @current?.unbind()
    @signIn null

Recent.belongsTo 'user', User
Favorite.belongsTo 'user', User
Classification.belongsTo 'user', User

exports = User
