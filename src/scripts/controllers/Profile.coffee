define (require, exports, module) ->
  $ = require 'jQuery'

  {delay, formatDate} = require 'zooniverse/util'
  config = require 'zooniverse/config'

  User = require 'zooniverse/models/User'
  BaseProfile = require 'zooniverse/controllers/Profile'
  Map = require 'zooniverse/controllers/Map'
  SpectrogramPlayer = require 'controllers/SpectrogramPlayer'
  Subject = require 'zooniverse/models/Subject'

  template = require 'views/Profile'

  class Profile extends BaseProfile
    template: template

    map: null
    spectrogramPlayers = null
    recentMarkings = null

    elements: $.extend
      '.map': 'mapContainer'
      '.scenes .count.value': 'classificationCount'
      '.bats .count.value': 'batCount'
      '.insects .count.value': 'insectCount'
      '.machines .count.value': 'machineCount'
      BaseProfile::elements

    constructor: ->
      super
      @spectrogramPlayers ?= []
      @recentMarkings ?= []
      @map = new Map
        latitude: 46
        longitude: 24.6
        zoom: 7
        el: @mapContainer

    userChanged: =>
      super

      if User.current
        @updateCounts()
        delay 1000, => @map.resized()

    updateFavorites: =>
      player.release() for player in @spectrogramPlayers
      @spectrogramPlayers = []
      super

    favoriteTemplate: (favorite) =>
      item = $("<li></li>")
      player = new SpectrogramPlayer
        image: favorite.subjects[0].location.standard
        audio: favorite.subjects[0].location.mp3
      @spectrogramPlayers.push player
      player.appendTo item
      $("<h4>#{formatDate favorite.createdAt}</h4>").appendTo item
      $("<a href='#{favorite.subjects[0].talkHref()}' target='_blank' class='talk'>Talk about it</a>").appendTo item
      $("<a href='#delete' data-favorite='#{favorite.id}' class='delete'>Remove favourite</a>").appendTo item
      item

    updateRecents: =>
      @el.toggleClass 'has-recents', User.current.recents.length > 0

      # TODO: This is pretty awful. See Cyclone Center for a better idea.
      @map.removeLayer label for label in @recentMarkings
      for recent in User.current.recents
        subject = recent.subjects[0]
        @recentMarkings.push @map.addLabel subject.coords..., """
          <img src="#{subject.location.standard || subject.location.image}" style="max-width: 100px !important;" /><br />
          <a href="#{Subject::talkHref.call subject}">Discuss</a>
        """

    updateCounts: =>
      url = "http://#{config.cartoUser}.cartodb.com/api/v2/sql?callback=?"

      query = 'SELECT ' +
        'SUM(ALL(bats)) AS bats, ' +
        'SUM(ALL(insects)) AS insects, ' +
        'SUM(ALL(machines)) AS machines, ' +
        'COUNT(ALL(created_at)) AS classifications ' +
        "FROM #{config.cartoTable} " +
        "where user_id='#{User.current.id}'"

      $.getJSON url, q: query, (response) =>
        @renderCounts response.rows[0]

    renderCounts: ({bats, insects, machines, classifications}) =>
      @batCount.html bats || 0
      @insectCount.html insects || 0
      @machineCount.html machines || 0
      @classificationCount.html classifications || 0

  module.exports = Profile
