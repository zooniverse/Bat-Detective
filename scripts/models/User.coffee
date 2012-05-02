Spine = require 'Spine'
$ = require 'jQuery'

Recent = require 'models/Recent'
Favorite = require 'models/Favorite'
Classification = require 'models/Classification'

Authentication = require 'Authentication'

class User extends Spine.Model
  @configure 'User', 'zooniverseId', 'username', 'apiKey', 'finishedTutorial'
  @hasMany 'recents', Recent
  @hasMany 'favorites', Favorite
  @hasMany 'classifications', Classification

  @current: null

  @signIn: (newCurrent) ->
    return if newCurrent is @current
    @current = newCurrent
    @trigger 'sign-in', @current

  @signOut: ->
    @current?.unbind()
    @signIn null

Recent.belongsTo 'user', User
Favorite.belongsTo 'user', User
Classification.belongsTo 'user', User

Authentication.bind 'login', (data) ->
  User.signIn User.create
    id: data.id
    zooniverseId: data.zooniverse_id
    username: data.name
    apiKey: data.api_key

Authentication.bind 'logout', ->
  User.signOut()

exports = User
