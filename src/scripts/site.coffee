define (require, exports, module) ->
  config = require 'zooniverse/config'

  App = require 'zooniverse/controllers/App'
  Project = require 'zooniverse/models/Project'
  Workflow = require 'zooniverse/models/Workflow'
  Subject = require 'zooniverse/models/Subject'

  Classifier = require 'controllers/Classifier'
  tutorialSteps = require 'tutorialSteps'

  Map = require 'zooniverse/controllers/Map'
  Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's.
  Map::tilesId = 61165
  Profile = require 'controllers/Profile'

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
          devID: 'PROJECT_DEV_ID'
          id: 'PROJECT ID'

          workflows: [
            new Workflow
              devID: 'PROJECT_DEV_ID'
              id: 'WORKFLOW ID'

              subjects: [
                # For development
                new Subject
                  location:
                    standard: 'examples/images/bat-social.jpg'
                    audio: 'examples/audio/bat-social.mp3'
                  coords: [0, 0]
                  metadata: {}
              ]

              tutorialSubjects: [
                new Subject
                  location:
                    standard: 'examples/images/bat-social.jpg'
                    audio: 'examples/audio/bat-social.mp3'
                  coords: [0, 0]
                  metadata: {}
              ]
          ]
      ]

  config.set
    classifier: new Classifier
      workflow: config.app.projects[0].workflows[0]
      el: '[data-page="classify"]'
      # tutorialSteps: tutorialSteps

    # homeMap: new Map
    #   el: '.home-map'

    # profile: new Profile
    #   el: '[data-page="profile"]'

  $ = require 'jQuery'

  window.refreshCSS = ->
    for link in $('link')
      href = $(link).attr 'href'
      href += '?refresh=' unless ~href.indexOf '?'
      $(link).attr 'href', href + 'X'
