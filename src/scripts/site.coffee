define (require, exports, module) ->
  $ = require 'jQuery'

  config = require 'zooniverse/config'
  ids = require 'ids'

  App = require 'zooniverse/controllers/App'
  Project = require 'zooniverse/models/Project'
  Workflow = require 'zooniverse/models/Workflow'
  Subject = require 'zooniverse/models/Subject'

  Classifier = require 'controllers/Classifier'
  tutorialSteps = require 'tutorialSteps'

  Map = require 'zooniverse/controllers/Map'
  Profile = require 'controllers/Profile'
  SpectrogramPlayer = require 'controllers/SpectrogramPlayer'

  config.set
    name: 'Bat Detective'
    slug: 'bat-detective'
    description: 'Help track bats across Europe'
    talkHost: 'http://talk.batdetective.org'

    domain: 'batdetective.org'
    googleAnalytics: 'UA-1224199-32'

    cartoUser: 'the-zooniverse'
    cartoTable: 'bat_detective'

  config.set
    app: new App
      el: '.bat-detective.app'
      appName: 'Bat Detective'
      languages: ['en']

      projects: new Project
        id: ids.project

        workflows: new Workflow
          id: ids.workflow

          tutorialSubjects: [
            new Subject
              id: ids.tutorialSubject
              location:
                standard: 'subjects/image/tutorial.jpg'
                mp3: 'subjects/audio/tutorial.mp3'
              coords: [0, 0]
              metadata: {}
          ]

          subjects: [
            # new Subject
            #   id: '5068c62054558f05df000001'
            #   location:
            #     standard: 'examples/images/bat-feeding-buzz.jpg'
            #     mp3: 'examples/audio/bat-feeding-buzz.mp3'
            #   coords: [0, 0]
            #   metadata: {}

            # new Subject
            #   id: '5068c62254558f05df000002'
            #   location:
            #     standard: 'examples/images/bat-searching-horizontal-hockey-stick.jpg'
            #     mp3: 'examples/audio/bat-searching-horizontal-hockey-stick.mp3'
            #   coords: [0, 0]
            #   metadata: {}

            # new Subject
            #   id: '5068c62354558f05df000003'
            #   location:
            #     standard: 'examples/images/bat-searching-plateau.jpg'
            #     mp3: 'examples/audio/bat-searching-plateau.mp3'
            #   coords: [0, 0]
            #   metadata: {}

            # new Subject
            #   id: '5068c62354558f05df000004'
            #   location:
            #     standard: 'examples/images/bat-searching-vertical-hockey-stick.jpg'
            #     mp3: 'examples/audio/bat-searching-vertical-hockey-stick.mp3'
            #   coords: [0, 0]
            #   metadata: {}

            # new Subject
            #   id: '5068c62454558f05df000005'
            #   location:
            #     standard: 'examples/images/bat-searching-vertical-line.jpg'
            #     mp3: 'examples/audio/bat-searching-vertical-line.mp3'
            #   coords: [0, 0]
            #   metadata: {}
          ]

  Map::apiKey = '21a5504123984624a5e1a856fc00e238' # TODO: This is Brian's.
  Map::tilesId = 61165

  config.set
    classifier: new Classifier
      workflow: config.app.projects[0].workflows[0]
      el: '[data-page="classify"]'
      tutorialSteps: tutorialSteps

    homeMap: new Map
      latitude: 52.5
      longitude: 23.25
      layers: ["http://d3clx83h4jp73a.cloudfront.net/tiles/#{config.cartoTable}/{z}/{x}/{y}.png"]
      el: '.home-map'

    profile: new Profile
      el: '[data-page="profile"]'

  for link in $('[data-page="about"] [data-page="bats"] a[href$=".mp3"]')
    link = $(link)
    player = new SpectrogramPlayer
      audio: link.attr 'href'

    player.el.insertBefore link
    link.remove()

  window.refreshCSS = ->
    for link in $('link')
      href = $(link).attr 'href'
      href += '?refresh=' unless ~href.indexOf '?'
      $(link).attr 'href', href + 'X'
