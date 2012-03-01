Spine = require 'Spine'

Classification = require 'models/Classification'

class Subject extends Spine.Model
	@configure 'Subject', 'image', 'audio', 'location', 'environment', 'datetime'
	@hasMany 'classifications', Classification
	@extend Spine.Model.Local

Classification.belongsTo 'subject', Subject

exports = Subject
