define (require, exports, module) ->
  {Step} = require 'zooniverse/controllers/Tutorial'

  module.exports = [
    new Step
      heading: 'Welcome to Bat Detective!'
      content: [
        'This image is a spectrogram, which is a visual representation of a sound.'
        'We\'ll use this image to pick out individual bat calls.'
      ]
      attach: to: '.interface .spectrogram img'

    new Step
      content: [
        'Click the play button to hear the sound.'
        'Listen closely to make out distinct calls and match them up with the marks on the image.'
        'In this sound we\'ll hear three sounds.'
      ]
      attach: x: 'left', y: 'bottom', to: '.interface .controls .play', at: x: 'left', y: 'top'
      nextOn: click: '.play'

    new Step
      content: [
        'First we\'ll select a range of frequencies.'
        'The first two sounds can be seen about halfway from the top. Because they\'re repeating in the same frequency range, it\'s very likely that they\'re from the same creature.'
        'Drag vertically from the top of the mark to the bottom to select the frequency range.'
      ]
      attach: y: 'top', to: '.spectrogram img', at: y: 'top'
      nextOn: mouseup: '.spectrogram'

    new Step
      content: [
        'Now we\'ll select the time ranges that the sounds take place in.'
        'Drag horizontally from the start of the first sound to the end of the first sound.'
      ]
      attach: x: 'left', to: '.spectrogram img', at: x: 'left'
      nextOn: mouseup: '.spectrogram'

    new Step
      content: [
        'Now do the same thing for the second sound.'
        'Drag horizontally from the start of the second sound to the end of the second sound.'
      ]
      attach: to: '.spectrogram img'
      nextOn: mouseup: '.spectrogram'

    new Step
      content: [
        'Now we\'ll identify the sound.'
        'Let\'s check out the field guide and find out what we\'re hearing.'
        'From the frequency range, we can guess that this is a bat. Click the "Bat calls" tab on the field guide.'
      ]
      attach: y: 'bottom', to: '.field-guide a[href="#!/classify/bat-calls"]', at: y: 'top'
      nextOn: click: '.field-guide a[href="#!/classify/bat-calls"]'

    new Step
      delay: 100
      content: [
        'Since these marks are shaped like horizontal hockey sticks, let\'s click to see an example.'
      ]
      attach: x: 'right', to: '.field-guide a[href="#!/classify/bat-calls/searching/horizontal-hockey-stick"]', at: x: 'left'
      nextOn: click: '.field-guide a[href="#!/classify/bat-calls/searching/horizontal-hockey-stick"]'

    new Step
      delay: 100
      content: [
        'And let\'s play it to see what it sounds like.'
      ]
      attach: x: 'right', to: '.field-guide [data-page="horizontal-hockey-stick"] .play', at: x: 'left'
      nextOn: click: '.field-guide [data-page="horizontal-hockey-stick"] .play'

    new Step
      content: [
        'Now we can identify this as a bat...'
      ]
      attach: x: 'right', to: '.interface .answer:contains("Bat Call")', at: x: 'left'
      nextOn: click: '.answer:contains("Bat Call")'

    new Step
      delay: 100
      content: [
        '...and a searching call...'
      ]
      attach: x: 'right', to: '.interface .answer:contains("Searching")', at: x: 'left'
      nextOn: click: '.answer:contains("Searching")'

    new Step
      delay: 100
      content: [
        '...and let\'s save this one.'
      ]
      attach: x: 'right', to: '.interface .answer:contains("Save selection")', at: x: 'left'
      nextOn: click: '.interface .answer:contains("Save selection")'

    new Step
      content: [
        'Now we\'ll select the sound at the bottom of the spectrogram.'
        'Select the frequency range by dragging from the top of the mark to the bottom.'
      ]
      attach: to: '.spectrogram img'
      nextOn: mouseup: '.spectrogram'

    new Step
      content: [
        'And then drag from the start of the sound to the end.'
      ]
      attach: to: '.spectrogram img'
      nextOn: mouseup: '.spectrogram'

    new Step
      content: [
        'Look through the field guide. It looks and sounds like this is an insect!'
      ]
      attach: y: 'bottom', to: '.field-guide a[href="#!/classify/insect-noise"]', at: y: 'top'
      nextOn: click: '.field-guide a[href="#!/classify/insect-noise"]'

    new Step
      content: [
        'Select insect...'
      ]
      attach: x: 'right', to: '.interface .answer:contains("Insect")', at: x: 'left'
      nextOn: click: '.answer:contains("Insect")'

    new Step
      delay: 100
      content: [
        '...then "save selection".'
      ]
      attach: x: 'right', to: '.interface .answer:contains("Save selection"):last', at: x: 'left'
      nextOn: click: '.answer:contains("Save selection")'

    new Step
      content: [
        'Now you\'re ready to investigate on your own.'
        'Click "next sound" to begin'
      ]
      attach: to: '.spectrogram img'
      nextOn: click: '.next-subject'
  ]
