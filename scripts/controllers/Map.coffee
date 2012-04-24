Spine = require 'Spine'

Leaflet = require 'Leaflet'

class Map extends Spine.Controller
  latitude: 50
  longitude: 20
  zoom: 5

  scrollWheelZoom: false
  doubleClickZoom: false

  # Set these before use.
  # Map = require 'controllers/map'
  # Map::apiKey = '1234567890'
  apiKey: ''
  tilesId: 997

  map: null

  constructor: ->
    super

    @map = new Leaflet.Map @el[0],
      center: new Leaflet.LatLng @latitude, @longitude
      zoom: @zoom
      layers: new Leaflet.TileLayer "http://{s}.tile.cloudmade.com/#{@apiKey}/#{@tilesId}/256/{z}/{x}/{y}.png"
      scrollWheelZoom: @scrollWheelZoom
      doubleClickZoom: @doubleClickZoom
      attributionControl: false
      zoomControl: false

  setCenter: (@latitude, @longitude) =>
    @map.setView new Leaflet.LatLng(@latitude, @longitude), @map.getZoom()

  setZoom: (@zoom) =>
    @map.setZoom @zoom

  resized: =>
    @map.invalidateSize()

exports = Map
