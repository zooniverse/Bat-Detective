$ = require 'jQuery'

Sonogram = require 'models/Sonogram'
App = require 'controllers/App'
NestedRoute = require 'NestedRoute'

parallax = require 'parallax'

window.app = new App
	el: $('#app')

NestedRoute.setup()

window.exampleSonogram = new Sonogram
	image: '/example-data/sonogram.jpg'
	url: ['http://upload.wikimedia.org/wikipedia/commons/9/94/Pipistrellus.ogg']
	location: 'Oxford, United Kingdom'
	environment: 'Residential area'
	datetime: 1234567891234

window.app.classifier.setModel window.exampleSonogram

exports = window.app
