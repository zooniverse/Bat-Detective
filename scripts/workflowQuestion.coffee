{Question, Answer} = require 'controllers/Workflow'

finish = new Question '',
	new Answer 'Clear',
		{}
		-> @model.destroy()

	new Answer 'Finish',
		{}
		-> @model.trigger 'finished'

exports = new Question 'What do you hear?',
	new Answer 'Bat Call',
		source: 'bat'
		new Question 'What type of bat call is this?',
			new Answer 'Social',
				type: 'social'
				finish

			new Answer 'Searching',
				type: 'searching'
				finish

			new Answer 'Feeding',
				type: 'feeding'
				finish

	new Answer 'Insect',
		type: 'insect',
		finish

	new Answer 'Machine',
		type: 'machine',
		finish
