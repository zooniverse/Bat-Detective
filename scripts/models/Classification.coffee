Spine = require 'Spine'
$ = require 'jQuery'

FrequencyRange = require 'models/FrequencyRange'

class Classification extends Spine.Model
  @configure 'Classification', 'subject'
  @hasMany 'frequencyRanges', FrequencyRange

  serialize: =>
    classification:
      subject_ids: [@subject.id]
      annotations: (range.serialize() for range in @frequencyRanges().all())

  persist: =>
    @trigger 'persisting'

    # Temporary:
    ouroboros = "http://localhost:3000"
    savePoint = "#{ouroboros}/projects/#{@subject.projectId}/workflows/#{@subject.workflowIds[0]}/classifications"

    $.post savePoint, @serialize()

  destroy: ->
    range.destroy() for range in @frequencyRanges().all()
    super

FrequencyRange.belongsTo 'classification', Classification

exports = Classification
