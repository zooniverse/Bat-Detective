Spine = require 'Spine'
{GoogleMaps} = require 'GoogleMaps'

class Map extends Spine.Controller
  center: null

  constructor: ->
    @setCenter @lat, @lng

  setCenter: (@lat, @lng) ->
    @center = new GoogleMaps.LatLng @lat, @lng

exports = Map
