Spine = require 'Spine'

Subject = require 'models/Subject'
Classification = require 'models/Classification'

class Recent extends Spine.Model
  @configure 'Recent', 'subject', 'classification'

exports = Recent
