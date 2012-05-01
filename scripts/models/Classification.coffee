Spine = require 'Spine'
$ = require 'jQuery'

FrequencyRange = require 'models/FrequencyRange'

class Classification extends Spine.Model
  @configure 'Classification', 'subject'
  @hasMany 'frequencyRanges', FrequencyRange

  serialize: =>
    user_id: @user().id
    # subject_ids: [@subject.id]
    subject_ids: ['4fa0034b54558f074e000006']
    annotations: (range.serialize() for range in @frequencyRanges().all())

  persist: =>
    # Temporary:
    ouroboros = 'http://localhost:3000'
    projectId = '4f9efc7754558f05eb000002'
    workflowId = '4f9efca154558f074e000001'

    $.post "#{ouroboros}/projects/#{projectId}/workflows/#{workflowId}/classifications",
      classification: @serialize()

  destroy: ->
    range.destroy() for range in @frequencyRanges().all()
    super

FrequencyRange.belongsTo 'classification', Classification

exports = Classification
