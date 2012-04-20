Spine = require 'Spine'

User = require 'models/User'
FrequencyRange = require 'models/FrequencyRange'

class Classification extends Spine.Model
  @configure 'Classification'
  @hasMany 'frequencyRanges', FrequencyRange
  @extend Spine.Model.Local

  serialize: =>
    user: User.current.id
    frequencyRanges: (range.serialize() for range in @frequencyRanges().all())

  saveRemotely: =>
    console.info 'POSTing', @serialize()

FrequencyRange.belongsTo 'classification', Classification

exports = Classification
