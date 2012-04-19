Spine = require 'Spine'

class User extends Spine.Model
  @configure 'User', 'username', 'finishedTutorial'
  @extend Spine.Model.Local

exports = User
