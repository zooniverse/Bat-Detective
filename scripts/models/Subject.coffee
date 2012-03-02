Spine = require 'Spine'

Classification = require 'models/Classification'

class Subject extends Spine.Model
	@configure 'Subject', 'image', 'audio', 'location', 'environment', 'datetime'
	@hasMany 'classifications', Classification
	@extend Spine.Model.Local

	@next: ->
		noClassifications = @select (subject) ->
			subject.classifications().all().length is 0

		noClassifications[0]

Classification.belongsTo 'subject', Subject

exports = Subject
