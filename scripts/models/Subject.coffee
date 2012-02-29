Spine = require 'Spine'

class TimeRange extends Spine.Model
	@configure 'FrequencyRange', 'start', 'end'
	@extend Spine.Model.Local

class FrequencyRange extends Spine.Model
	@configure 'FrequencyRange', 'low', 'high', 'source', 'type'
	@hasMany 'timeRanges', TimeRange
	@extend Spine.Model.Local

class Classification extends Spine.Model
	@configure 'Classification'
	@hasMany 'frequencyRanges', FrequencyRange
	@extend Spine.Model.Local

class Subject extends Spine.Model
	@configure 'Subject', 'image', 'audio', 'location', 'environment', 'datetime'
	@hasMany 'classifications', Classification
	@extend Spine.Model.Local

exports = Subject
