define (require, exports, module) ->
  $ = require 'jQuery'

  {formatDate} = require 'zooniverse/util'

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
      @map.resized()

    updateFavorites: =>
      player.release() for player in @spectrogramPlayers
      @spectrogramPlayers = []
      super

    favoriteTemplate: (favorite) =>
      item = $("<li></li>")
      player = new SpectrogramPlayer
        image: favorite.subjects[0].location.image
        audio: favorite.subjects[0].location.audio
      @spectrogramPlayers.push player
      player.appendTo item
      $("<h4>#{formatDate favorite.createdAt}</h4>").appendTo item
      $("<a href='#{favorite.subjects[0].talkHref()}' class='talk'>Talk about it</a>").appendTo item
      $("<button data-favorite='#{favorite.id}' class='delete'>Remove favorite</button>").appendTo item
      item

    recentTemplate: (recent) =>
      item = $('<li></li>')
      $("<a href='#{recent.subjects[0].talkHref()}' class='talk'>#{formatDate recent.createdAt}</a>").appendTo item
      item

  module.exports = Profile
