define (require, exports, module) ->
  User = require 'zooniverse/models/User'
  {Controller} = require 'Spine'
  template = require 'zooniverse/views/TopBar'
  Dialog = require 'zooniverse/controllers/Dialog'
  LoginForm = require 'zooniverse/controllers/LoginForm'

  class TopBar extends Controller
    className: 'zooniverse-top-bar'

    events:
      'click button[name="login"]'   : 'logIn'
      'click button[name="signup"]'  : 'startSignUp'
      'click button[name="signout"]' : 'signOut'
      'keypress input'               : 'logInOnEnter'
      'click a.top-bar-button'       : 'toggleDisplay'
      'change select.language'       : 'setLanguage'

    elements:
      '#zooniverse-top-bar-container'        : 'container'
      '#app-name'                            : 'appNameContainer'
      '#zooniverse-top-bar-login .login'     : 'loginContainer'
      '#zooniverse-top-bar-login .welcome'   : 'welcomeContainer'
      'select.language'                      : 'langSelect'
      '.login .progress'                     : 'progress'
      '.login .errors'                       : 'errors'

    constructor: ->
      super
      @app ||= "test"
      @appName ||= "Test Name"
      @currentLanguage ||= 'en'

      # User.project = @app
      User.bind 'sign-in', @setUser
      User.bind 'sign-in-error', @onError

      # User.fetch().always =>
      #   @toggleDisplay() unless User.current

      @render()
      @setAppName()
      @initLanguages()
      @setUser()

      if User.currentChecked
        @toggleDisplay() unless User.current
      else
        User.bind 'sign-in', =>
          return if User.currentChecked
          @toggleDisplay() unless User.current

    logIn: (e) =>
      username = @el.find('input[name="username"]').val()
      password = @el.find('input[name="password"]').val()

      if (username != '') and (password != '')
        @el.find('.progress').show()

        auth = User.authenticate {username, password}
        auth.fail @onError

    signOut: (e) =>
      User.deauthenticate()

    startSignUp: (e) =>
      dialog = new Dialog
        content: ''
        buttons: [{'Cancel': null}]
        target: @el.parent()
        className: 'classifier'

      loginForm = new LoginForm

      dialog.contentContainer.append loginForm.el
      loginForm.signUp()
      dialog.reposition()

    toggleDisplay: (e) =>
      e?.preventDefault()
      @el.parent().toggleClass 'show-top-bar'

    render: =>
      @html template

    setAppName: ->
      @appNameContainer.append @appName

    setUser: =>
      if User.current
        # @signUp.el.remove()
        @loginContainer.hide()
        @errors.empty()
        @welcomeContainer.html @userGreeting(User.current.name)
        @welcomeContainer.show()
        setTimeout @toggleDisplay, 1000 if @el.parent().hasClass 'show-top-bar'
      else
        @welcomeContainer.hide()
        @loginContainer.show()
        @progress.hide()

    userGreeting: (user) ->
      """
      <div class="inputs">
        <h3> Hi, <strong>#{user}</strong>. Welcome to #{@appName}!</h3>
      </div>
      <div class="buttons">
        <button name="signout" type="button">Sign Out</button>
      </div>
      """

    onError: (error) =>
      @progress.hide()
      @errors.text(error)
      @errors.show()

    initLanguages: =>
      for shortLang, longLang of @languages
        @langSelect.append """<option value="#{shortLang}">#{shortLang.toUpperCase()}</option>"""
      @langSelect.val('en')

    setLanguage: (e) =>
      @currentLanguage = @langSelect.val()
      @el.trigger 'request-translation', @currentLanguage

    logInOnEnter: (e) =>
      @logIn() if (e.keyCode == 13)

  module.exports = TopBar
