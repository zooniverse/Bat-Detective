Spine = require 'Spine'

FrequencyRange = require 'models/FrequencyRange'

class Classification extends Spine.Model
  @configure 'Classification', 'subject'
  @hasMany 'frequencyRanges', FrequencyRange

  serialize: =>
    user: @user().id
    subject: @subject.id
    frequencyRanges: (range.serialize() for range in @frequencyRanges().all())

  saveRemotely: =>
    console.info 'POSTing', @serialize()

FrequencyRange.belongsTo 'classification', Classification

exports = Classification
