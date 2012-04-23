Spine = require 'Spine'

Classification = require 'models/Classification'

class Subject extends Spine.Model
	@configure 'Subject', 'image', 'audio', 'latitude', 'longitude', 'location', 'habitat', 'datetime'

	@next: ->
    subjects = Subject.all()
    random = Math.floor Math.random() * subjects.length
    subjects[random]

exports = Subject
