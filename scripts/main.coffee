$ = require 'jQuery'

User = require 'models/User'
johnDoe = User.create username: 'john-doe'
User.signIn johnDoe

Map = require 'controllers/Map'
Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's. Does Zooniverse have one?
Map::tilesId = 35905
map = new Map el: $('#home-map')

ZooniverseBar = require 'lib/ZooniverseBar'
new ZooniverseBar el: $('#zooniverse-bar')

Pager = require 'lib/Pager'
pagers = (new Pager el: parent for parent in $('[data-page]').parent())

Subject = require 'models/Subject'
for i in [1..10] then Subject.create
	image: "example-data/images/#{i}.png"
	audio: "example-data/audio/#{i}.mp3"
	location: 'Oxford, United Kingdom'
	environment: 'Residential area'
	datetime: +new Date()
	commonSpecies: 'Vampire bats'

SonogramClassifier = require 'controllers/SonogramClassifier'
classifier = new SonogramClassifier
	el: $('#sound-classifier')
	subject: Subject.first()

FieldGuide = require 'controllers/FieldGuide'
fieldGuide = new FieldGuide
	el: $('#field-guide')
	classifier: classifier

Profile = require 'controllers/Profile'
profile = new Profile
	el: $('#profile')

AudioButton = require 'controllers/AudioButton'
new AudioButton el: button for button in $('[data-audio-src]')

Route = require 'lib/Route'
Route.checkRoutes()

# Globals for dev
window.map = map
window.User = require 'models/User'
window.Subject = require 'models/Subject'
window.Classification = require 'models/Classification'
window.classifier = classifier
window.fieldGuide = fieldGuide
window.profile = profile
