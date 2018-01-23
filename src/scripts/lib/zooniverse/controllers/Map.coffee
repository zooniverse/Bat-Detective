define (require, exports, module) ->
  Spine = require 'Spine'
  Leaflet = require 'Leaflet'
  require 'leafletProviders'
  $ = require 'jQuery'

  {delay} = require 'zooniverse/util'

  class Map extends Spine.Controller
    latitude: 41.9
    longitude: -87.6
    zoom: 10

    layers: null
    cartoLogo: false

    zoomControl: true
    scrollWheelZoom: false
    doubleClickZoom: false

    # Set these before use.
    # NOTE: These are no longer used. CloudMade dropped support.
    apiKey: ''
    tilesId: 998

    # Pick one from http://leaflet-extras.github.io/leaflet-providers/preview/index.html
    tilesProvider: 'Esri.WorldImagery'

    map: null

    constructor: ->
      super

      @layers ?= []
      @layers = [@layers] unless @layers instanceof Array

      @map = new Leaflet.Map @el.get(0),
        center: new Leaflet.LatLng @latitude, @longitude
        zoom: @zoom
        layers: [
          new Leaflet.TileLayer.Provider @tilesProvider
          (new Leaflet.TileLayer url for url in @layers)...
        ]
        scrollWheelZoom: @scrollWheelZoom
        doubleClickZoom: @doubleClickZoom
        attributionControl: false
        zoomControl: @zoomControl

      # If the map isn't immediately visible, resize it after a bit.
      mapSize = @map.getSize()
      if 0 in [mapSize.x, mapSize.y] then delay 1000, @resized

      if @cartoLogo
        logo = $('''
          <a href="http://www.cartodb.com/" target="_blank" class="cartodb-logo">
            <img src="images/cartodb-logo.png" />
          </a>
        ''')

        logo.appendTo @el

    setCenter: (@latitude, @longitude) =>
      @map.setView new Leaflet.LatLng(@latitude, @longitude), @map.getZoom()

    setZoom: (@zoom) =>
      @map.setZoom @zoom

    addLayer: (url) =>
      layer = new Leaflet.TileLayer url
      @map.addLayer layer
      layer

    removeLayer: (layer) =>
      @map.removeLayer layer

    resized: =>
      @map.invalidateSize()

    addLabel: (lat, lng, html, radius = 5) =>
      latLng = new Leaflet.LatLng lat, lng, true
      label = new Leaflet.CircleMarker latLng, {radius}
      @map.addLayer label
      label.bindPopup html if html
      label

  module.exports = Map
