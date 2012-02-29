$ = require 'jQuery'

parallax = require 'parallax'

Pager = require 'controllers/Pager'
pagers = $('[data-page]').parent().map ->
	new Pager
		el: @

Subject = require 'models/Subject'
window.exampleSonogram = Subject.create
	image: '/example-data/sonogram.jpg'
	audio: ['http://upload.wikimedia.org/wikipedia/commons/9/94/Pipistrellus.ogg']
	location: 'Oxford, United Kingdom'
	environment: 'Residential area'
	datetime: +new Date()

SonogramClassifier = require 'controllers/SonogramClassifier'
window.classifier = new SonogramClassifier
	el: $('#sound-classifier')
	subject: window.exampleSonogram

NestedRoute = require 'NestedRoute'
NestedRoute.setup()

exports = window.classifier
