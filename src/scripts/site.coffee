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
  
  API = require 'zooniverse/API'

  noop = ->
  window.console ||=
    log: noop
    debug: noop
    info: noop
    warn: noop
    error: noop

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
                standard: 'tutorial/tutorial.jpg'
                mp3: 'tutorial/tutorial.mp3'
              coords: [0, 0]
              metadata: {}
          ]

  config.set
    classifier: new Classifier
      workflow: config.app.projects[0].workflows[0]
      el: '[data-page="classify"]'
      tutorialSteps: tutorialSteps

    profile: new Profile
      el: '[data-page="profile"]'

  for link in $('[data-page="about"] [data-page="bats"] a[href$=".mp3"]')
    link = $(link)
    player = new SpectrogramPlayer
      audio: link.attr 'href'

    player.el.insertBefore link
    link.remove()

# classification challenge progress
  TARGET = 100000
  START = 400000
  $('.challenge-target').html TARGET.toLocaleString()
  API.fetchProject ids.project, (project) ->
    count = parseInt project.classification_count
    $('.challenge-current').html count.toLocaleString()
    progress = Math.min (count - START) / (TARGET), 1
    $('.progress-bar .progress').css 'width', "#{parseInt progress * 100}%"
    
  window.refreshCSS = ->
    for link in $('link')
      href = $(link).attr 'href'
      href += '?refresh=' unless ~href.indexOf '?'
      $(link).attr 'href', href + 'X'
