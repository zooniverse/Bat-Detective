define (require, exports, module) ->
  Spine = require 'Spine'

  config = require 'zooniverse/config'

  User = require 'zooniverse/models/User'
  TopBar = require 'zooniverse/controllers/TopBar'
  Pager = require 'zooniverse/controllers/Pager'
  GoogleAnalytics = require 'zooniverse/controllers/GoogleAnalytics'
  {translateDocument} = require 'zooniverse/i18n'

  class App extends Spine.Controller
    appName: ''
    languages: null # Array like ['en', 'po'] passed to TopBar
    projects: null # Array of Project model instances

    googleAnalytics: null

    constructor: ->
      super

      @projects ?= []
      @projects = [@projects] unless @projects instanceof Array
      project.app = @ for project in @projects

      @initTopBar()
      @initPagers()
      @initAnalytics()

      User.checkCurrent @projects[0]
      translateDocument @languages[0] # TODO: Respect user preference.

    initTopBar: =>
      @topBar = new TopBar {@languages, @appName}
      @topBar.el.prependTo 'body'

    initPagers: =>
      for pageContainer in @el.find('[data-page]').parent()
        new Pager el: pageContainer

    initAnalytics: =>
      if config.googleAnalytics
        @googleAnalytics = new GoogleAnalytics
          account: config.googleAnalytics
          domain: config.domain

  module.exports = App
