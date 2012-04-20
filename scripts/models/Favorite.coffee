Spine = require 'Spine'

Subject = require 'models/Subject'
Classification = require 'models/Classification'

class Favorite extends Spine.Model
  @configure 'Favorite', 'subject', 'classification'

exports = Favorite
