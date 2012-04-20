Spine = require 'Spine'

User = require 'models/User'

template = require 'lib/text!views/Profile.html'

class Profile extends Spine.Controller
  template: template

  elements:
    'header .username': 'username'
    '.favorites': 'favoritesList'
    '.recent .location': 'recentLocation'
    '.recent .date': 'recentDate'
    '.findings .scenes .count': 'scenesCount'
    '.findings .bats .count': 'batsCount'
    '.findings .insects .count': 'insectsCount'
    '.findings .machines .count': 'machinesCount'
    '.associations .groups': 'groupsList'

  constructor: ->
    super
    @html @template
    User.bind 'change-current', @userChanged

    @userChanged User.current

  userChanged: (user) =>
    return unless user
    user.bind 'change', @render
    @render()

  render: =>
    @el.toggleClass 'signed-in', User.current?

    return unless User.current?

    @username.html User.current.username

    @favoritesList.empty()
    for favorite in User.current.favorites().all()
      @favoritesList.append "<li>#{favorite.subject.location}</li>" # TODO

exports = Profile
