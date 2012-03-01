Spine = require 'Spine'

TimeRange = require 'models/TimeRange'

class FrequencyRange extends Spine.Model
	@configure 'FrequencyRange', 'low', 'high', 'source', 'type'
	@hasMany 'timeRanges', TimeRange
	@extend Spine.Model.Local

	validate: ->
		return '"Low" must be greater than or equal to zero' unless @low >= 0
		return '"High" must be less than or equal to one' unless @high <= 1
		return '"Low" must be less than "high"' unless @low < @high
		return 'Minimum range is 1%' unless @high - @low >= 0.01

TimeRange.belongsTo 'frequencyRange', FrequencyRange, 'frequency_range_id'

exports = FrequencyRange
