Spine = require 'Spine'

FrequencyRange = require 'models/FrequencyRange'

class Classification extends Spine.Model
	@configure 'Classification'
	@hasMany 'frequencyRanges', FrequencyRange
	@extend Spine.Model.Local

FrequencyRange.belongsTo 'classification', Classification

exports = Classification
