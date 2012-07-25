define (require, exports, module) ->
  $ = require 'jQuery'

  {delay, formatDate} = require 'zooniverse/util'

  User = require 'zooniverse/models/User'
  BaseProfile = require 'zooniverse/controllers/Profile'
  Map = require 'zooniverse/controllers/Map'
  SpectrogramPlayer = require 'controllers/SpectrogramPlayer'

  template = require 'views/Profile'

  class Profile extends BaseProfile
    template: template

    map: null
    spectrogramPlayers = null

    elements: $.extend
      '.map': 'mapContainer'
      BaseProfile::elements

    constructor: ->
      super
      @spectrogramPlayers ?= []
      @map = new Map
        el: @mapContainer

    userChanged: =>
      super
      delay => @map.resized()

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
      $("<a href='#{favorite.subjects[0].talkHref()}' class='talk'>Talk about it</a>").appendTo item
      $("<a href='#delete' data-favorite='#{favorite.id}' class='delete'>Remove favorite</a>").appendTo item
      item

    updateRecents: =>
      @el.toggleClass 'has-recents', User.current.recents.length > 0
      recent = User.current.recents.slice(-1)[0]
      @recentsList.empty()
      return unless recent?
      @recentsList.append "<a href='#{recent.subjects[0].talkHref()}'>#{formatDate recent.createdAt}</a>"

  module.exports = Profile
