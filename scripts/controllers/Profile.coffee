Spine = require 'Spine'

User = require 'models/User'

Map = require 'controllers/Map'

template = require 'lib/text!views/Profile.html'

class Profile extends Spine.Controller
  template: template

  map: null

  elements:
    'header .username': 'username'
    '.map': 'mapContainer'
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

    @map = new Map el: @mapContainer, zoom: 6

    User.bind 'sign-in', @userChanged

    @userChanged User.current

  userChanged: (user) =>
    return unless User.current

    User.current.bind 'change', @render

    @render()

  render: =>
    @el.toggleClass 'signed-in', User.current?

    return unless User.current?

    @username.html User.current.username

    @favoritesList.empty()
    for favorite in User.current.favorites().all()
      @favoritesList.append "<li>#{favorite.subject.location}</li>" # TODO

    recentClassification = User.current.recents().all()[0]

    @el.toggleClass 'has-recents', recentClassification?
    @map.resized()

    if recentClassification?
      @map.setCenter recentClassification.subject.latitude, recentClassification.subject.longitude
      @recentLocation.html recentClassification.subject.location
      @recentDate.html new Date # TODO


    if false # TODO: Groups
      groups = User.current.groups().all()
      @el.toggleClass 'has-groups', groups.length > 0


exports = Profile
