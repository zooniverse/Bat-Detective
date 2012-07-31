define (require, exports, module) ->
  $ = require 'jQuery'
  {Step} = require 'zooniverse/controllers/Tutorial'
  {delay} = require 'zooniverse/util'

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
      onEnter: ->
        highlighter = $('<div class="highlighter"></div>')
        highlighter.css left: 0, height: '0.01%', opacity: 0, top: '45%', width: '100%'
        highlighter.appendTo '[data-page="classify"] .interface .spectrogram'

        delay 4000, =>
          highlighter.animate height: '9%', opacity: 1, 'slow'
          highlighter.animate opacity: 0, 'slow', ->
            highlighter.css height: '0.01%', opacity: 0
            highlighter.animate height: '9%', opacity: 1, 'slow'
            highlighter.animate opacity: 0, 'slow', ->
              highlighter.remove()

    new Step
      heading: 'Mark the time ranges'
      content: [
        'Within the frequency range, there are four pulses of noise. Mark horizontally from the beginning to the end of each noise within the highlighted frequency.'
        'Click "Continue" when you\'re ready. Don\'t forget the fourth one at the end!'
      ]
      attach: y: 'top', to: '.spectrogram img', at: y: 'top'
      onEnter: ->
        highlights = window.h = $([
          '<div class="highlighter" style="left: 14%;"></div>'
          '<div class="highlighter" style="left: 41%;"></div>'
          '<div class="highlighter" style="left: 69%;"></div>'
          '<div class="highlighter" style="left: 97%;"></div>'
        ].join '')
        highlights.css height: '10%', opacity: 0, top: '45%', width: '0.01%'
        highlights.appendTo '[data-page="classify"] .interface .spectrogram'

        highlights.eq(0).animate opacity: 1, width: '7%', 'slow', ->
          highlights.eq(1).animate opacity: 1, width: '8%', 'slow', ->
            highlights.eq(2).animate opacity: 1, width: '9%', 'slow', ->
              highlights.eq(3).animate opacity: 1, width: '3%', 'slow', ->
                delay 1000, ->
                  highlights.eq(0).animate left: '+=7%', opacity: 0, width: '0.01%', 'slow', ->
                    highlights.eq(1).animate left: '+=8%', opacity: 0, width: '0.01%', 'slow', ->
                      highlights.eq(2).animate left: '+=9%', opacity: 0, width: '0.01%', 'slow', ->
                        highlights.eq(3).animate left: '+=3%', opacity: 0, width: '0.01%', 'slow', ->
                          highlights.remove()


    new Step
      heading: 'What is this sound?'
      content: [
        'Let\'s scroll down to the field guide and figure out what we\'re hearing.'
        'From the frequency range, we can guess that this is a bat, so check out the examples in the "Bat calls" tab.'
      ]
      style: width: 600
      attach: x: 'left', y: 'bottom', to: '.field-guide a[href="#!/classify/bat-calls"]', at: x: 'left', y: 'top'
      onEnter: (tutorial) ->
        end = $('.field-guide').offset().top - ($(window).innerHeight() / 2)
        $('html, body').animate scrollTop: end

    new Step
      delay: 100
      content: [
        'This selection looks and sounds like a bat making a searching call.'
        'Pick "Bat call"...'
      ]
      attach: x: 'right', to: '.answer:contains("Bat call")', at: x: 'left'
      style: width: 380
      nextOn: click: '.answer:contains("Bat call")'
      onEnter: (tutorial) ->
        $('html, body').animate scrollTop: 0

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
      onEnter: ->
        highlighters = $([
          '<div class="highlighter" style="height: 17%; left: 4%; top: 50%; width: 5%;"></div>'
          '<div class="highlighter" style="height: 17%; left: 39%; top: 50%; width: 5%;"></div>'
          '<div class="highlighter" style="height: 17%; left: 74%; top: 50%; width: 5%;"></div>'
          '<div class="highlighter" style="height: 12%; left: 26%; top: 76%; width: 25%;"></div>'
          '<div class="highlighter" style="height: 11%; left: 1%; top: 83%; width: 98%;"></div>'
        ].join '')
        highlighters.css opacity: 0
        highlighters.appendTo '[data-page="classify"] .interface .spectrogram'

        for highlighter, i in highlighters then do (highlighter, i) ->
          highlighter = $(highlighter)
          delay i * 500, ->
            highlighter.animate opacity: 1, 'slow'
            delay highlighters.length * 1000, ->
              highlighter.animate opacity: 0, 'slow', ->
                highlighter.remove()
  ]
