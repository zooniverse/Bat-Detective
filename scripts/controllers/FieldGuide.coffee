Spine = require 'Spine'

Map = require 'controllers/Map'

TEMPLATE = require 'lib/text!views/FieldGuide.html'

class FieldGuide extends Spine.Controller
	subject: null

	className: 'field-guide'
	template: TEMPLATE
	fields: ['location', 'habitat', 'date', 'time', 'commonSpecies']

	elements:
		'.map': 'mapContainer'
		'.location > .field': 'locationField'
		'.habitat > .field': 'habitatField'
		'.commonSpecies > .field': 'commonSpeciesField'
		'.date > .field': 'dateField'
		'.time > .field': 'timeField'

	map: null

	constructor: ->
		super

		@html @template

		@map = new Map el: @mapContainer[0], latitude: 50, longitude: 0, zoom: 4

		@setSubject @subject if @subject?

	setSubject: (@subject) =>
		@map.setCenter @subject.latitude, @subject.longitude

		@locationField.html @subject.location
		@habitatField.html @subject.habitat
		@commonSpeciesField.html @subject.commonSpecies

exports = FieldGuide
