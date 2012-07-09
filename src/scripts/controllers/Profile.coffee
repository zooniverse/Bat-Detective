define (require, exports, module) ->
  $ = require 'jQuery'

  {formatDate} = require 'zooniverse/util'

  BaseProfile = require 'zooniverse/controllers/Profile'
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

    updateFavorites: =>
      player.release() for player in @spectrogramPlayers || []
      @spectrogramPlayers = []
      super

    favoriteTemplate: (favorite) =>
      item = $('<li></li>')
      player = new SpectrogramPlayer
        image: favorite.subjects[0].location.image
        audio: favorite.subjects[0].location.audio
      @spectrogramPlayers.push player
      player.appendTo item
      $("Classified #{formatDate favorite.createdAt}").appendTo item
      $("<a href='favorite.'#{}'>Talk about it</a>").appendTo item
      item

  module.exports = Profile
