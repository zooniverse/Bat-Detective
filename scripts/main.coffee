$ = require 'jQuery'

Map = require 'controllers/Map'
Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's. Does Zooniverse have one?
Map::tilesId = 61165
homeMap = new Map el: $('#home-map')

ZooniverseBar = require 'lib/ZooniverseBar'
new ZooniverseBar el: $('#zooniverse-bar')

Pager = require 'lib/Pager'
pagers = (new Pager el: parent for parent in $('[data-page]').parent())

SonogramClassifier = require 'controllers/SonogramClassifier'
classifier = new SonogramClassifier
	el: $('#sound-classifier')

FieldGuide = require 'controllers/FieldGuide'
fieldGuide = new FieldGuide
	el: $('#field-guide')

Profile = require 'controllers/Profile'
profile = new Profile
	el: $('#profile')

AudioButton = require 'controllers/AudioButton'
new AudioButton el: button for button in $('[data-audio-src]')

Route = require 'lib/Route'
Route.checkRoutes()

Subject = require 'models/Subject'
Subject.fetch().then (subject) =>
	Subject.setCurrent subject

# Globals for dev
window.User = require 'models/User'
window.Subject = require 'models/Subject'
window.Classification = require 'models/Classification'
window.homeMap = homeMap
window.classifier = classifier
window.profile = profile
