define (require, exports, module) ->
  {dev} = require 'zooniverse/config'

  module.exports = if dev
    project: 'bat_detective'
    workflow: '4fa0321854558f2fbf000003'
    tutorialSubject: '4ff8306854558fc372000001'
  else
    project: 'bat_detective'
    workflow: 'WORKFLOW_ID'
    tutorialSubject: 'TUTORIAL_SUBJECT_ID'
