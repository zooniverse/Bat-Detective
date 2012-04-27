$ = require 'jQuery'

eventHub = $({})

# Production
authHost = 'http://login.zooniverse.org:3000'
authPath = '/'

# Development
if parseFloat(location.port) is 3475
  authHost = "#{location.protocol}//#{location.host}"
  authPath = '/mock-login.html'

frameMarkup = "<iframe src='#{authHost}#{authPath}' style='display: none'></iframe>"
authenticator = $(frameMarkup).appendTo('body')[0].contentWindow

$(window).on 'message', ({originalEvent: e}) ->
  return unless e.origin is authHost
  eventHub.trigger action, data for action, data of e.data

exports =
  on: (event, callback) ->
    eventHub.on event, (e, args...) ->
      callback args...

  off: (args...) ->
    eventHub.off args...

  authenticate: (username, password) ->
    authenticator.postMessage authenticate: {username, password}, authHost

  checkCurrent: ->
    authenticator.postMessage 'current', authHost
