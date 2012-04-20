$ = require 'jQuery'

User = require 'models/User'
johnDoe = User.create username: 'john-doe'
User.signIn johnDoe

ZooniverseBar = require 'lib/ZooniverseBar'
new ZooniverseBar el: $('#zooniverse-bar')

# Clear out local storage between views.
localStorage?.clear()

Pager = require 'lib/Pager'
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

Profile = require 'controllers/Profile'
window.profile = new Profile
	el: $('#profile')

AudioButton = require 'controllers/AudioButton'
new AudioButton el: button for button in $('[data-audio-src]')

Route = require 'lib/Route'
Route.checkRoutes()

