$ = require 'jQuery'

User = require 'models/User'
$.ajaxSetup beforeSend: (xhr) ->
  if User.current?
    auth = btoa "#{ User.current.username }:#{ User.current.apiKey }" # TODO: IE
    xhr.setRequestHeader 'Authorization', "Basic #{ auth }"

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

Tutorial = require 'lib/Tutorial'
tutorialSteps = require 'tutorialSteps'
tutorial = new Tutorial
  el: '[data-page="classify"]'
  steps: tutorialSteps

Subject = require 'models/Subject'
if true
  Subject.setCurrent Subject.forTutorial
  tutorial.start()


FieldGuide = require 'controllers/FieldGuide'
fieldGuide = new FieldGuide
	el: $('#field-guide')

Profile = require 'controllers/Profile'
profile = new Profile
	el: $('#profile')

AudioButton = require 'controllers/AudioButton'
new AudioButton el: button for button in $('[data-audio-src]')

Subject.fetch().then (subject) =>
	Subject.setCurrent subject unless Subject.current is Subject.forTutorial

Route = require 'lib/Route'
Route.checkRoutes()

# Globals for dev
window.User = require 'models/User'
window.Subject = require 'models/Subject'
window.Classification = require 'models/Classification'
window.Recent = require 'models/Recent'
window.Favorite = require 'models/Favorite'

window.homeMap = homeMap
window.classifier = classifier
window.tutorial = tutorial
window.profile = profile
