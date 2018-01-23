define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  API = require 'zooniverse/API'
  {remove} = require 'zooniverse/util'

  Subject = require 'zooniverse/models/Subject'
  User = require 'zooniverse/models/User'

  # NOTE: This is also the Recent class, for now.

  class Favorite extends Spine.Module
    @extend Spine.Events
    @include Spine.Events

    @className: 'Favorite'

    @instances: []

    @fromJSON: (raw) ->
      new @
        id: raw.id
        createdAt: raw.created_at
        projectID: raw.project_id
        subjects: (Subject.fromJSON subject for subject in raw.subjects)

    @refresh: ({page} = {page: 1}) ->
      @instances[0].destroy() while @instances.length > 0 unless page > 1
      return unless User.current?

      fetch = API["fetch#{@className}s"] {project: User.project, user: User.current}, {page}
      fetch.done (response) =>
        for raw in response
          instance = @fromJSON raw
          instance.projectID = User.project.id || User.project

    id: ''
    createdAt: null
    projectID: 'NO_PROJECT_ID'
    subjects: null

    constructor: (params = {}) ->
      @[property] = value for own property, value of params

      @createdAt ?= new Date
      @subjects ?= []

      @constructor.instances.push @
      addMap = {}
      addMap[@constructor.className.toLowerCase()] = @
      User.current?.add addMap

    toJSON: =>
      favorite:
        subject_ids: (subject.id for subject in @subjects)

    persist: =>
      @trigger 'persisting'

      post = API.createFavorite
        project: @projectID
        subjects: @subjects

      post.done (response) =>
        @id = response.id
        @trigger 'persist'

      post.fail (response) =>
        @trigger 'error', response

    destroy: (fromServer) =>
      remove @, from: @constructor.instances

      removeMap = {}
      removeMap[@constructor.className.toLowerCase()] = @
      User.current?.remove removeMap

      if fromServer is true
        API["destroy#{@constructor.className}"] $.extend {project: @projectID}, removeMap

  module.exports = Favorite
