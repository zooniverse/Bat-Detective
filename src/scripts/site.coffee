define (require, exports, module) ->
  config = require 'zooniverse/config'

  App = require 'zooniverse/models/App'
  Project = require 'zooniverse/models/Project'
  Workflow = require 'zooniverse/models/Workflow'
  Subject = require 'zooniverse/models/Subject'

  Classifier = require 'controllers/Classifier'
  tutorialSteps = require 'tutorialSteps'
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
          id: 'PROJECT ID'

          workflows: [
            new Workflow
              id: 'WORKFLOW ID'

              controller: new Classifier
                el: '[data-page="classify"]'
                tutorialSteps: tutorialSteps

              tutorialSubjects: [
                new Subject
                  location: 'TUTORIAL SUBJECT LOCATION'
                  coords: [0, 0]
                  workflow: {}
              ]
          ]
      ]

    profile: new Profile
      el: '[data-page="profile"]'
