Spine = require 'Spine'

class TimeRange extends Spine.Model
	@configure 'TimeRange', 'start', 'end'
	@extend Spine.Model.Local

	validate: ->
		return '"Start" must be greater than zero' unless @start >= 0
		return '"End" must be less than one' unless @end <= 1
		return '"Start" must be less than "end"' unless @start < @end
		return 'Minimum length is 1%' unless @end - @start >= 0.01

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

class Classification extends Spine.Model
	@configure 'Classification'
	@hasMany 'frequencyRanges', FrequencyRange
	@extend Spine.Model.Local

FrequencyRange.belongsTo 'classification', Classification

class Subject extends Spine.Model
	@configure 'Subject', 'image', 'audio', 'location', 'environment', 'datetime'
	@hasMany 'classifications', Classification
	@extend Spine.Model.Local

Classification.belongsTo 'subject', Subject

exports = Subject
