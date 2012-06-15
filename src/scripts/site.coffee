define (require, exports, module) ->
  config = require 'zooniverse/config'

  App = require 'zooniverse/models/App'
  Project = require 'zooniverse/models/Project'
  Workflow = require 'zooniverse/models/Workflow'
  Subject = require 'zooniverse/models/Subject'

  Classifier = require 'controllers/Classifier'
  tutorialSteps = require 'tutorialSteps'

  Map = require 'zooniverse/controllers/Map'
  Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's.
  Map::tilesId = 61165
  Profile = require 'controllers/Profile'

  SpectrogramPlayer = require 'controllers/SpectrogramPlayer'

  config.set
    name: 'Bat Detective'
    slug: 'bat-detective'
    description: 'PROJECT DESCRIPTION'

    talkHost: 'http://talk.batdetective.org'

    cartoUser: 'CARTODB USER'
    cartoApiKey: 'CARTODB API KEY'
    cartoTable: 'CARTODB TABLE'
    facebookId: 'FACEBOOK APP ID'

    app: new App
      el: '.bat-detective.app'
      languages: ['en']

      projects: [
        new Project
          id: 'PROJECT ID'

          workflows: [
            new Workflow
              id: 'WORKFLOW ID'

              # controller: new Classifier
              #   el: '[data-page="classify"]'
              #   tutorialSteps: tutorialSteps

              tutorialSubjects: [
                new Subject
                  location: 'TUTORIAL SUBJECT LOCATION'
                  coords: [0, 0]
                  workflow: {}
              ]
          ]
      ]

    demoPlayer: new SpectrogramPlayer
      image: 'examples/images/bat-feeding-buzz.jpg'
      audio: 'examples/audio/bat-feeding-buzz.mp3'

    # homeMap: new Map
    #   el: '.home-map'

    # profile: new Profile
    #   el: '[data-page="profile"]'

  config.demoPlayer.el.appendTo 'body'
  config.demoPlayer.el.css
    left: 0
    position: 'absolute'
    top: 0
    zIndex: '20'
