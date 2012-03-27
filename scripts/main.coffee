$ = require 'jQuery'

# Clear out local storage between views.
localStorage?.clear()

parallax = require 'parallax'

Pager = require 'controllers/Pager'
pagers = $('[data-page]').parent().map ->
	new Pager
		el: @

Subject = require 'models/Subject'
for i in [1..10] then Subject.create
	image: "example-data/images/#{i}.png"
	audio: "example-data/audio/#{i}.mp3"
	location: 'Oxford, United Kingdom'
	environment: 'Residential area'
	datetime: +new Date()
	commonSpecies: 'Vampire bats'

SonogramClassifier = require 'controllers/SonogramClassifier'
window.classifier = new SonogramClassifier
	el: $('#sound-classifier')
	subject: Subject.first()

FieldGuide = require 'controllers/FieldGuide'
window.fieldGuide = new FieldGuide
	el: $('#field-guide')
	classifier: window.classifier

NestedRoute = require 'NestedRoute'
NestedRoute.setup()

exports = window.classifier
