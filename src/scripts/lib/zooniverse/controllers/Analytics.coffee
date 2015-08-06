define (require, exports, module) ->
  $ = require 'jQuery'

  config = require 'zooniverse/config'

  User = require 'zooniverse/models/User'

  # A simple cookie-based tracking pixel
  # The uniqueness of a visit is determined by expiring cookie values
  # If a cookie value hasn't expired yet, it means the visit isn't unique
  class Analytics
    constructor: ->
      @initialize()
      @listen()

    # listen for an event that triggers a pageview and track a visit
    listen: ->
      # triggered when the app determines if we have a current user
      # Zooniverse.bind 'analytics-visit', @visit

      # hashchange events are basically a new pageview
      $(window).on 'hashchange', @visit

    # setup
    initialize: ->
      # the tracking pixel
      @image = new Image

      # the current time
      @now = new Date

      # the number of days in the current month
      @daysInMonth = new Date(@now.getFullYear(), @now.getMonth() + 1, 0).getDate()

      # time units with abbreviations for the params
      @i = @minute = 60
      @h = @hour = 60 * @minute
      @d = @day = 24 * @hour
      @m = @month = @daysInMonth * @day
      @y = @year = 365 * @day
      @u = @decade = 10 * @year
      @times = ['u', 'y', 'm', 'd', 'h', 'i']

    # track a user visit
    visit: =>
      return if ~location.hash.indexOf '...' # This will be replaced immediately.

      if User.current?
        # set the pixel url including user id
        @setUrl "&user_id=#{ User.current.id }"
      else
        # set the pixel url
        @setUrl()

      # set the cookies
      @setTimes()

    # set the pixel url (triggers the request) with optional params
    setUrl: (extras = '') -> @image.src = "#{ @url() }#{ extras }"

    # the url of the pixel
    url: -> "#{ config.apiHost }/analytics/visit?#{ @params() }"

    # prefix cookie key names with 'zooniverse_'
    zoo: (key) -> "zooniverse_#{ key }"

    # test for a cookie value -- 0 if it exists, 1 if it does not
    test: (key) -> if @get key then 0 else 1

    # set cookie values for each time unit
    setTimes: -> @orSet time for time in @times

    # set a cookie value unless it exists
    orSet: (key) -> @set key, @[key] unless @get key

    # serialize a hash into params
    serialize: (obj) -> ("#{ key }=#{ encodeURIComponent val }" for key, val of obj).join '&'

    # params to pass to the tracking pixel
    params: -> @serialize
      project_id: config.app.projects[0].id
      path: document.location.pathname
      hash: document.location.hash
      'u[u]': @test 'u'
      'u[y]': @test 'y'
      'u[m]': @test 'm'
      'u[d]': @test 'd'
      'u[h]': @test 'h'
      'u[i]': @test 'i'

    # read a cookie value
    get: (key) ->
      key = @zoo key
      strings = document.cookie.split ';'
      for string in strings
        position = string.indexOf('=')
        name = string.substr(0, position).replace /^\s+|\s+$/g, ''
        if name is key
          return unescape string.substr(position + 1)
      null

    # set a cookie value with expiry in seconds
    set: (key, time) ->
      expires = new Date
      expires.setTime( expires.getTime() + (time * 1000) )
      document.cookie = "#{ @zoo key }=1; expires=#{ expires.toUTCString() }"

  module.exports = Analytics
