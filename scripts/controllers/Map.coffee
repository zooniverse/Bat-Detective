Spine = require 'Spine'

Leaflet = require 'Leaflet'

class Map extends Spine.Controller
  latitude: 50
  longitude: 20
  zoom: 5

  scrollWheelZoom: false

  apiKey: '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's. Is there a Zooniverse one?
  tilesId: 35905

  map: null

  constructor: ->
    super

    @map = new Leaflet.Map @el[0],
      center: new Leaflet.LatLng @latitude, @longitude
      zoom: @zoom
      layers: new Leaflet.TileLayer "http://{s}.tile.cloudmade.com/#{@apiKey}/#{@tilesId}/256/{z}/{x}/{y}.png"
      scrollWheelZoom: @scrollWheelZoom
      attributionControl: false
      zoomControl: false      

  setCenter: (@latitude, @longitude) =>
    @map.setView new Leaflet.LatLng @latitude, @longitude

  setZoom: (@zoom) =>
    @map.setZoom @zoom

exports = Map
