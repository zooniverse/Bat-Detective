Spine = require 'Spine'

Subject = require 'models/Subject'

class Recent extends Spine.Model
  @configure 'Recent', 'subject', 'date'

exports = Recent
