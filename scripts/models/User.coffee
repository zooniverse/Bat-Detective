Spine = require 'Spine'
$ = require 'jQuery'

Classification = require 'models/Classification'
Recent = require 'models/Recent'
Favorite = require 'models/Favorite'

Authentication = require 'Authentication'
Subject = require 'models/Subject'

class User extends Spine.Model
  @configure 'User', 'zooniverseId', 'username', 'apiKey', 'finishedTutorial'
  @hasMany 'classifications', Classification
  @hasMany 'recents', Recent
  @hasMany 'favorites', Favorite

  @fromJSON: (raw) ->
    super
      id: raw.id
      zooniverseId: raw.zooniverse_id
      username: raw.name
      apiKey: raw.api_key

  @current: null

  @signIn: (newCurrent) ->
    return if newCurrent is @current
    @current = newCurrent
    @trigger 'sign-in', @current

  refreshRecents: =>
    $.get "#{Subject.server}/projects/#{Subject.projectId}/users/#{User.current.id}/recents", (response) =>
      console.log 'RECENTS:', response

  @signOut: ->
    @current?.unbind()
    @signIn null

Recent.belongsTo 'user', User
Favorite.belongsTo 'user', User
Classification.belongsTo 'user', User

Authentication.bind 'login', (data) ->
  User.signIn User.fromJSON(data)

Authentication.bind 'logout', ->
  User.signOut()

exports = User
