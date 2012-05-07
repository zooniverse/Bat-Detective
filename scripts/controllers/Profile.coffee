Spine = require 'Spine'

User = require 'models/User'
authentication = require 'authentication'

Map = require 'controllers/Map'
SignInForm = require 'controllers/SignInForm'

template = require 'lib/text!views/Profile.html'

class Profile extends Spine.Controller
  template: template

  map: null

  events:
    'click header .sign-out': 'signOut'

  elements:
    '.sign-in-or-up': 'signInFormContainer'
    'header .username': 'username'
    '.map': 'mapContainer'
    '.favorites ul': 'favoritesList'
    '.recent .location .value': 'recentLocation'
    '.recent .date .value': 'recentDate'
    '.findings .scenes .count': 'scenesCount'
    '.findings .bats .count': 'batsCount'
    '.findings .insects .count': 'insectsCount'
    '.findings .machines .count': 'machinesCount'
    '.groups ul': 'groupsList'

  constructor: ->
    super

    @html @template
    @signInForm = new SignInForm el: @signInFormContainer
    @map = new Map el: @mapContainer, zoom: 6

    User.bind 'sign-in', @userChanged
    @userChanged()

  userChanged: =>
    User.current?.bind 'change', @render
    @render()

  render: =>
    @el.toggleClass 'signed-in', User.current?

    return unless User.current?

    @username.html User.current.username

    # NOTE: Temporarily using recents as favorites!
    favorites = User.current.recents().all()

    @el.toggleClass 'has-favorites', favorites.length > 0
    @favoritesList.empty()
    for favorite in favorites
      favoriteItem = $("<li></li>")

      # TODO: Figure out the right URLs with which to socialize.
      favoriteItem.append """
        <div class="social">
          <iframe src="//platform.twitter.com/widgets/tweet_button.html?url=#{favorite.image}" allowtransparency="true" frameborder="0" scrolling="no" style="width: 80px; height: 20px;"></iframe>
          <br />
          <iframe src="//www.facebook.com/plugins/like.php?href=#{favorite.image}&amp;send=false&amp;layout=button_count&amp;width=450&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:80px; height:21px;" allowTransparency="true"></iframe>
        </div>
      """

      favoriteItem.append "<img src='#{favorite.image}' class='framed' />"

      favoriteItem.append "<h4>#{favorite.place}</h4>"
      favoriteItem.append (new Date favorite.createdAt).toString().split(' ')[1..3].join ' '

      @favoritesList.append favoriteItem

    recentClassification = User.current.recents().first()

    @el.toggleClass 'has-recents', recentClassification?
    @map.resized()

    if recentClassification?
      @map.setCenter recentClassification.latitude, recentClassification.longitude
      @recentLocation.html recentClassification.place
      @recentDate.html (new Date recentClassification.createdAt).toString().split(' ')[1..3].join ' '

    if false # TODO: Groups
      groups = User.current.groups().all()
      @el.toggleClass 'has-groups', groups.length > 0

  signOut: (e) =>
    e.preventDefault()
    authentication.logOut()

exports = Profile
