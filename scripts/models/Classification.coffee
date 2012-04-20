Spine = require 'Spine'

FrequencyRange = require 'models/FrequencyRange'

class Classification extends Spine.Model
  @configure 'Classification'
  @hasMany 'frequencyRanges', FrequencyRange
  @extend Spine.Model.Local

  serialize: =>
    frequencyRanges: (range.serialize() for range in @frequencyRanges().all())

  saveRemotely: =>
    console.info 'POSTing', @serialize()

FrequencyRange.belongsTo 'classification', Classification

exports = Classification
