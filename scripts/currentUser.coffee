User = require 'models/User'

currentUser = User.create
  username: 'zooniverse-user'
  finishedTutorial: true

exports = currentUser
