Spine = require 'Spine'

template = require 'lib/text!views/Profile.html'

class Profile extends Spine.Controller
  template: template

  elements:
    'header .username': 'username'
    'favorites': 'favoritesList'
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

  render: ->

exports = Profile
