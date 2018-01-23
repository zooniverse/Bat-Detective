define (require, exports, module) ->
  Spine = require 'Spine'
  $ = window.jQuery

  {delay} = require 'zooniverse/util'

  User = require 'zooniverse/models/User'
  Favorite = require 'zooniverse/models/Favorite'
  Recent = require 'zooniverse/models/Recent'

  LoginForm = require 'zooniverse/controllers/LoginForm'
  TEMPLATE = require 'zooniverse/views/Profile'

  class Profile extends Spine.Controller
    className: 'zooniverse-profile'
    template: TEMPLATE

    events:
      'click .sign-out': 'signOut'
      'click .favorites .delete': 'onFavoriteDeleteClick'
      'click .recents button[name="more"]': 'loadMoreRecents'
      'click .favorites button[name="more"]': 'loadMoreFavorites'

    elements:
      '.username': 'usernameContainer'
      '.login-form': 'loginFormContainer'
      '.favorites ul': 'favoritesList'
      '.recents ul': 'recentsList'
      '.groups ul': 'groupsList'

    recentsPage: 1
    favoritesPage: 1

    constructor: ->
      super
      @html @template
      @loginForm = new LoginForm el: @loginFormContainer

      User.bind 'sign-in', @userChanged

      User.bind 'add-favorite remove-favorite', @updateFavorites

      User.bind 'add-recent remove-recent', @updateRecents

      delay @userChanged

    userChanged: =>
      @el.toggleClass 'signed-in', User.current?

      if User.current?
        @usernameContainer.html User.current.name
        Favorite.refresh()
        Recent.refresh()

    favoriteTemplate: (favorite) =>
      "<li>#{favorite.createdAt}</li>"

    updateFavorites: =>
      # TODO: Pagination
      @favoritesList.empty()
      favorites = User.current.favorites
      @el.toggleClass 'has-favorites', favorites.length > 0
      @favoritesList.prepend @favoriteTemplate favorite for favorite in favorites

    recentTemplate: (recent) =>
      "<li>#{recent.subjects[0].location}</li>"

    updateRecents: =>
      @recentsList.empty()
      recents = User.current.recents
      @el.toggleClass 'has-recents', recents.length > 0
      @recentsList.prepend @recentTemplate recent for recent in recents

    signOut: (e) =>
      e.preventDefault()
      User.deauthenticate()

    onFavoriteDeleteClick: (e) =>
      # TODO: This is kinda hacky. This should be a list of controllers,
      # and destroying a model should remove its controller/view automatically.
      target = $(e.target)
      favoriteID = target.data 'favorite'
      favorite = (f for f in User.current.favorites when f.id is favoriteID)[0]

      favorite.destroy true
      target.parent('li').remove()

      e?.preventDefault?()

    loadMoreRecents: =>
      @recentsPage += 1
      Recent.refresh page: @recentsPage

    loadMoreFavorites: =>
      @favoritesPage += 1
      Favorite.refresh page: @favoritesPage

  module.exports = Profile
