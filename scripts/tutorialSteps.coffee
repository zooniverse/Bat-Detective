{Step} = require 'lib/Tutorial'

exports = [
  new Step
    style: left: '25%', top: '10%', width: '50%'
    content: [
      'Welcome to Bat Detective!'
      'You\'re about to help us identify bats and their habitats. This short tutorial will get you started.'
    ]

  new Step
    style: left: '10%', top: '5%'
    content: [
      'This image represents a soundwave recorded by a vehicle on the search for bats. The brighter the mark, the louder the sound.'
      'Because bat sounds are very high in frequency, we\'ve slowed the audio down to a tenth its normal speed so we can hear them. The audio in each three second audio clip actually took place in just one third of a second!'
      'Identifying a sound involves first highlighting its frequency range, then the individual sounds.'
      'Let\'s get started!'
    ]

  new Step
    style: left: '2%', top: '5%', width: '30%'
    content: [
      'First we\'ll identify this high frequency sound.'
      'First, drag your mouse down the image to highlight the frequency range of the sound.'
    ]

  new Step
    style: left: '25%', top: '22%', width: '30%'
    content: [
      'Now we\'ll highlight the first mark in that frequency range by dragging over it left to right.'
    ]

  new Step
    style: top: '8%'
    content: [
      'Next we\'ll highlight this second one.'
    ]

  new Step
    style: left: '41%', top: '1%'
    content: [
      'On the right we\'re going to be asked some questions about the marks we just highlighted.'
      'Let\'s take a look at the Field Guide below to learn what\'s making the sounds we hear.'
    ]

  new Step
    style: left: '11%', width: '60%'
    content: [
      'Flip through the different pages of the Field Guide. Look at and listen to the different images and sounds until you find a match for what you see and hear in the image above.'
      'According to the Field Guide, it looks like the best match bat making a searching call. Let\'s choose "bat call" first...'
    ]

  new Step
    style: left: '51%', width: '20%'
    content: [
      'Then "searching"...'
    ]

  new Step
    style: left: '38%', width: '33%'
    content: [
      'Then "next range" to highlight the next frequency.'
    ]

  new Step
    style: left: '3%', top: '17%', width: '29%'
    content: [
      'We\'ll do the same thing to mark this sound.'
      'First highlight the frequency range...'
    ]

  new Step
    style: top: '23%', width: '29%'
    content: ['Then highlight the first of the seven faint noises...']
    nextOn: click: '*'

  new Step
    style: left: '13%', width: '8%'
    content: ['The second...']
    nextOn: click: '*'

  new Step
    style: left: '20%'
    content: ['The third...']
    nextOn: click: '*'

  new Step
    style: left: '33%'
    content: ['The fourth...']
    nextOn: click: '*'

  new Step
    style: left: '41%'
    content: ['The fifth...']
    nextOn: click: '*'

  new Step
    style: left: '54%'
    content: ['The sixth...']
    nextOn: click: '*'

  new Step
    style: left: '55%', width: '12%'
    content: ['And finally the last.']
    nextOn: click: '*'

  new Step
    style: left: '39%', top: '7%', width: '32%'
    content: [
      'According to the Field Guide, this sound is an insect.'
    ]

  new Step
    content: [
      'Let\'s finish up this range so you can move on to the next one.'
    ]

  new Step
    style: left: '33%', top: '25%' width: '38%'
    content: [
      'Great job! Click "next sound" to get searching on your own!'
      'If you still need help, check out our <a href="#">video introduction</a>.'
    ]
]
