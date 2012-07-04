define (require, exports, module) ->
  {Question, Answer} = require 'controllers/Decision'

  finish = new Question '',
    new Answer 'Save selection',
      {}
      -> @annotation.trigger 'finish'

  module.exports = new Question 'What do you hear?',
    new Answer 'Bat Call',
      source: 'bat'
      new Question 'What type of bat call is this?',
        new Answer 'Social',
          type: 'social'
          finish

        new Answer 'Searching',
          type: 'searching'
          finish

        new Answer 'Feeding',
          type: 'feeding'
          finish

    new Answer 'Insect',
      source: 'insect', type: null
      finish

    new Answer 'Machine',
      source: 'machine', type: null
      finish
