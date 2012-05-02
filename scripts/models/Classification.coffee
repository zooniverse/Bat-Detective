Spine = require 'Spine'
$ = require 'jQuery'

Subject = require 'models/Subject'
FrequencyRange = require 'models/FrequencyRange'

class Classification extends Spine.Model
  @configure 'Classification', 'subject'
  @hasMany 'frequencyRanges', FrequencyRange

  serialize: =>
    classification:
      subject_ids: [Subject.current.id]
      annotations: (range.serialize() for range in @frequencyRanges().all())

  persist: =>
    @trigger 'persisting'

    # Temporary:
    savePoint = "#{Subject.server}/projects/#{Subject.projectId}/workflows/#{Subject.workflowId}/classifications"

    $.post savePoint, @serialize(), => @trigger 'persist'

  destroy: ->
    range.destroy() for range in @frequencyRanges().all()
    super

FrequencyRange.belongsTo 'classification', Classification

exports = Classification
