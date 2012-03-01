Spine = require 'Spine'

class TimeRange extends Spine.Model
	@configure 'TimeRange', 'start', 'end'
	@extend Spine.Model.Local

	validate: ->
		return '"Start" must be greater than zero' unless @start >= 0
		return '"End" must be less than one' unless @end <= 1
		return '"Start" must be less than "end"' unless @start < @end
		return 'Minimum length is 1%' unless @end - @start >= 0.009

exports = TimeRange
