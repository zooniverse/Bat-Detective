console.warn 'HERE'

Spine = require 'Spine'

class User extends Spine.Model
  @configure 'User', 'username', 'finishedTutorial'
  @extend Spine.Model.Local

  constructor: ->
    @recents = []
    @favorites = []

  # TODO: It'd be cool if we could set up recents and favorites as proper relations.

  addRecent: (subject) =>
    @recents.push subject
    while @recents.length > 10 then @recents.shift()
    @trigger 'change', @recents
    @trigger 'change-recents', @recents

  addFavorite: (subject) =>
    @favorites.push subject
    @trigger 'change', @favorites
    @trigger 'change-favorites', @favorites

  @current: null

  @signIn: (@current) ->
    @trigger 'change-current', @current

  @signOut: ->
    @signIn null

exports = User
