Spine = require 'Spine'
$ = require 'jQuery'

Recent = require 'models/Recent'
Favorite = require 'models/Favorite'
Classification = require 'models/Classification'

# NOTE: Login-related code here is a placeholder.

authHost = 'http://login.zooniverse.org:3000'
authPath = '/'

authFrame = $("<iframe src='#{authHost}#{authPath}' style='display: none'></iframe>")[0]
$('body').append authFrame

class User extends Spine.Model
  @configure 'User', 'id', 'username', 'apiKey', 'finishedTutorial'
  @hasMany 'recents', Recent
  @hasMany 'favorites', Favorite
  @hasMany 'classifications', Classification

  @current: null

  @authenticate: (username, password) ->
    authFrame.postMessage {username, password}, authHost

  @signIn: (@current) ->
    @trigger 'sign-in', @current

  @signOut: ->
    @current?.unbind()
    @signIn null

Recent.belongsTo 'user', User
Favorite.belongsTo 'user', User
Classification.belongsTo 'user', User

$(window).on 'message', (e) ->
  return unless e.origin is 'http://www.example.com:8080'

  if e.data.success
    User.signOut()

    User.signIn new User
      username: e.data.name
      id: e.data.zooniverse_id
      apiKey: e.data.api_key
  else
    if e.data.message
      alert e.data.message

exports = User
