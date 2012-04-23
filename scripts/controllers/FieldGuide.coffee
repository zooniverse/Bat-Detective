Spine = require 'Spine'

TEMPLATE = require 'lib/text!views/FieldGuide.html'

class FieldGuide extends Spine.Controller
	classifier: null

	className: 'field-guide'
	template: TEMPLATE
	fields: ['location', 'habitat', 'date', 'time', 'commonSpecies']

	constructor: ->
		super

		@elements = {}
		@elements["> .#{name} > .field"] = "#{name}Field" for name in @fields

		@html @template

	render: =>
		# TODO

exports = FieldGuide
