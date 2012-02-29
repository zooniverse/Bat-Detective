Spine = require 'Spine'

class FrequencySelector extends Spine.Controller
	range: null

	constructor: ->
		super
		@range.bind 'change', @onRangeChange

	# Called when the mouse is initially put down on the sonogram
	begin: (percent) ->

	onRangeChange: =>
		@log 'Range changed', @range.toJSON()

exports = FrequencySelector
