Spine = require 'Spine'

authentication = require 'authentication'
User = require 'models/User'

SIGN_IN_FORM_TEMPLATE = require 'lib/text!views/SignInForm.html'

class SignInForm extends Spine.Controller
  className: 'sign-in-form'
  template: SIGN_IN_FORM_TEMPLATE

  events:
    'submit .sign-in form': 'onSubmit'
    'click .sign-out button': 'signOut'

  elements:
    '.errors': 'errors'
    '.sign-in input[name="username"]': 'usernameField'
    '.sign-in input[name="password"]': 'passwordField'

  constructor: ->
    super
    @html @template

    User.bind 'sign-in', @onSignIn
    authentication.bind 'error', @onError

  onSubmit: (e) =>
    e.preventDefault()
    @el.removeClass 'has-error'
    @errors.empty()
    authentication.authenticate @usernameField.val(), @passwordField.val()

  onError: (error) =>
    @el.removeClass 'signed-in'
    @el.addClass 'has-error'
    @errors.html "<div>#{error}</div>"

  onSignIn: =>
    @el.toggleClass 'signed-in', User.current?
    @usernameField.add(@passwordField).val ''

  signOut: =>
    authentication.logOut()

exports = SignInForm
