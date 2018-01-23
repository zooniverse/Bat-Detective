define (require, exports, module) ->
  Spine = require 'Spine'
  $ = window.jQuery

  User = require 'zooniverse/models/User'
  API = require 'zooniverse/API'

  Subject = require 'zooniverse/models/Subject'

  class Workflow extends Spine.Module
    @include Spine.Events

    queueLength: 5 # Number of subjects to have on hand
    selectionLength: 1 # Number of subjects to be classified at a time

    project: null

    subjects: null # Available subjects queue
    tutorialSubjects: null # Predefined subject for tutorial

    selection: null # Selected subjects, removed from queue

    constructor: (params = {}) ->
      @[property] = value for own property, value of params

      @subjects ?= []
      @subjects = [@subjects] unless @subjects instanceof Array

      @tutorialSubjects ?= []
      @tutorialSubjects = [@tutorialSubjects] unless @tutorialSubjects instanceof Array

      subject.workflow = @ for subject in @subjects.concat @tutorialSubjects

      @selection ?= []

      User.bind 'sign-in', =>
        # console.log 'Workflow detected sign in'
        # When a user signs in, they'll need a whole new queue.
        @subjects.pop() until @subjects.length is 0 if User.current?
        @fetchSubjects().done =>
          if User.current?.tutorialDone
            @selectNext()
          else
            @selectTutorial()

    fetchSubjects: (group) =>
      @trigger 'fetching-subjects'
      @enough = new $.Deferred

      limit = @queueLength - @subjects.length

      # If there are enough subjects in the queue, resolve the deferred immediately.
      if @subjects.length > @selectionLength
        @enough.resolve @subjects

      unless limit is 0
        # console.log 'Workflow fetching subjects...',
        #   'Need:', @queueLength, 'have:', @subjects.length, 'fetching:', limit

        currentSubjectIDs = (subject.id for subject in @subjects)

        fetch = API.fetchSubjects {@project, group, limit}

        fetch.done (response) =>
          for rawSubject in response
            # Sometimes we get nulls when the database gets screwed up.
            # This shouldn't happen in production.
            continue unless rawSubject?

            # Rarely we can get a subject that's already in the queue.
            # This becomes more common as more subjets are retired.
            # TODO: Re-request subjects to keep the queue full.
            continue if rawSubject.id in currentSubjectIDs

            subject = Subject.fromJSON rawSubject
            subject.workflow = @
            @subjects.push subject

            # Preload subject images
            src = subject.location.standard
            src ?= subject.location.image
            if src
              img = $("<img src='#{src}' />")
              img.css height: 0, opacity: 0, position: 'absolute', width: 0
              img.appendTo 'body'

          @trigger 'fetch-subjects', @subjects
          @enough.resolve @subjects unless @enough.isResolved()

      @enough.promise()

    selectNext: =>
      # console.log 'Workflow changing selection'
      if @subjects.length >= @selectionLength
        @selection = @subjects.splice 0, @selectionLength
        @trigger 'change-selection', @selection
      else
        @trigger 'selection-error', @selection

    selectTutorial: =>
      return unless @tutorialSubjects.length > 0
      @subjects.unshift @tutorialSubjects...
      @selectNext()
      @trigger 'select-tutorial'

  module.exports = Workflow
