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

		@el.html @template
		@refreshElements()

	render: =>
		# TODO: Update the map.
		@["#{name}Field"].html @classifier.subject[name] for name in @fields

exports = FieldGuide
