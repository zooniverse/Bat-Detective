define (require, exports, module) ->
  $ = require 'jQuery'
  {Step} = require 'zooniverse/controllers/Tutorial'

  module.exports = [
    new Step
      heading: 'Welcome to Bat Detective'
      content: [
        'Your mission is to listen to a short audio clip and use its visual representation&mdash;called a spectrogram&mdash;to help classify bat calls!'
      ]
      attach: to: '.interface .spectrogram img'
      style: width: 360

    new Step
      heading: 'Play the audio clip'
      content: [
        'First, click play to listen to the 3-second audio clip. There could be multiple sounds in the clip. To help differentiate noises, see if you can match the audio to the visualization in the spectrogram.'
      ]
      style: width: 300
      attach: x: 'left', y: 'bottom', to: '.interface .controls .play', at: x: 'left', y: 'top'
      nextOn: click: '.play'

    new Step
      heading: 'Mark the frequency range'
      content: [
        'Choose the first noise you want to identify. Generally, spikes in noise within the same frequency represent an individual call. You\'ll need to drag vertically down the spectrogram to highlight the frequency range of a single call.'
        'Let\'s start with the first set of small calls about halfway down the spectrogram (at about 55 Khz).'
      ]
      attach: y: 'top', to: '.spectrogram img', at: y: 'top'
      style: width: 550
      nextOn: mouseup: '.spectrogram'

    new Step
      heading: 'Mark the time ranges'
      content: [
        'Within the frequency range, there are four pulses of noise. Mark horizontally from the beginning to the end of each noise within the highlighted frequency.'
        'Click "Continue" when you\'re ready. Don\'t forget the fourth one at the end!'
      ]
      attach: y: 'top', to: '.spectrogram img', at: y: 'top'

    new Step
      heading: 'What is this sound?'
      content: [
        'Let\'s scroll down to the field guide and figure out what we\'re hearing.'
        'From the frequency range, we can guess that this is a bat, so check out the examples in the "Bat calls" tab.'
      ]
      style: width: 600
      attach: x: 'left', y: 'bottom', to: '.field-guide a[href="#!/classify/bat-calls"]', at: x: 'left', y: 'top'
      onEnter: (tutorial) ->
        html = $('html')
        start = html.scrollTop()
        end = $('.field-guide').offset().top - ($(window).innerHeight() / 2)

        $('<div></div>').css(opacity: 0).animate {opacity: 1}, step: (i) ->
          html.get(0).scrollTop = start + ((end - start) * i)

    new Step
      delay: 100
      content: [
        'This selection looks and sounds like a bat making a searching call.'
        'Pick "Bat call"...'
      ]
      attach: x: 'right', to: '.answer:contains("Bat call")', at: x: 'left'
      style: width: 380
      nextOn: click: '.answer:contains("Bat call")'

    new Step
      delay: 100
      content: [
        '...and "Searching"...'
      ]
      attach: x: 'right', to: '.answer:contains("Searching")', at: x: 'left'
      nextOn: click: '.answer:contains("Searching")'

    new Step
      delay: 100
      content: [
        '...and finally "Save selection".'
      ]
      attach: x: 'right', to: '.answer:contains("Save selection")', at: x: 'left'
      nextOn: click: '.answer:contains("Save selection")'

    new Step
      content: [
        'Try the others on your own. Remember to consult the field guide if you\'re not sure what something is.'
        'If you see something interesting, you can talk about your findings with scientists and other volunteers after you\'re done classifying.'
      ]
      attach: y: 'top', to: '.spectrogram img', at: y: 'top'
      style: width: 480
      continueText: 'Exit tutorial'
  ]
