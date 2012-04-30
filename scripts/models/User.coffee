Spine = require 'Spine'
$ = require 'jQuery'

Recent = require 'models/Recent'
Favorite = require 'models/Favorite'
Classification = require 'models/Classification'

authentication = require 'authentication'

class User extends Spine.Model
  @configure 'User', 'id', 'username', 'apiKey', 'finishedTutorial'
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

authentication.bind 'login', (data) ->
  User.signIn User.create
    username: data.name
    id: data.zooniverse_id
    apiKey: data.api_key

authentication.bind 'logout', ->
  User.signOut()

exports = User
