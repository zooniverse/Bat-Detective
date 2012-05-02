Spine = require 'Spine'

Subject = require 'models/Subject'
Map = require 'controllers/Map'

TEMPLATE = require 'lib/text!views/FieldGuide.html'

months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

class FieldGuide extends Spine.Controller
	subject: null

	className: 'field-guide'
	template: TEMPLATE
	fields: ['location', 'habitat', 'date', 'time', 'commonSpecies']

	elements:
		'.map': 'mapContainer'
		'.location > .field': 'locationField'
		'.habitat > .field': 'habitatField'
		'.date > .field': 'dateField'
		'.time > .field': 'timeField'

	map: null

	constructor: ->
		super

		@html @template

		@map = new Map el: @mapContainer[0], latitude: 50, longitude: 0, zoom: 4

		Subject.bind 'change-current', @setSubject

	setSubject: (@subject) =>
		@map.setCenter @subject.latitude, @subject.longitude

		@locationField.html @subject.location
		@habitatField.html @subject.habitat

		captured = new Date @subject.captured

		@dateField.html """
			#{captured.getDate()}
			#{months[captured.getMonth()]},
			#{captured.getFullYear()}
		"""
		@timeField.html """#{captured.getHours()}:#{captured.getMinutes()}"""

exports = FieldGuide
