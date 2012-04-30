Spine = require 'Spine'
$ = require 'jQuery'

class Authentication extends Spine.Module
  @extend Spine.Events

  @host = "#{location.protocol}//#{location.host}"
  @path = '/authentication.html'

  @frame = $("<iframe src='#{@host}#{@path}'></iframe>")
  @frame.css display: 'none'
  @frame.appendTo 'body'

  @external = @frame.get(0).contentWindow

  @post = (message) ->
    @external.postMessage message, @host

  @authenticate = (username, password) ->
    @post authenticate: {username, password}

  @logOut = ->
    @post 'log-out': {}

# Event data comes as: {command: '', response: {}}
$(window).on 'message', ({originalEvent: e}) ->
  if e.data.response.success is true
    Authentication.trigger e.data.command, e.data.response
  else
    Authentication.trigger 'error', e.data.response.message

exports = Authentication
