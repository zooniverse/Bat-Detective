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

    @current.refreshRecents()

  refreshRecents: =>
    @trigger 'refreshing-recents'

    $.getJSON "#{Subject.server}/projects/#{Subject.projectId}/users/#{User.current.id}/recents", (response) =>
      for recent in response
        try
          console.log recent
          @recents().find recent.id
        catch error
          @recents().create
            id: recent.id
            subject: recent.subjects[0].id
            place: recent.subjects[0].metadata.location
            latitude: recent.subjects[0].coords[0]
            longitude: recent.subjects[0].coords[1]
            createdAt: +(new Date recent.created_at)

      @trigger 'refresh-recents'
      @trigger 'change'

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
