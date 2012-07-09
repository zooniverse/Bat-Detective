define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'
  soundManager = require 'soundManager'

  {delay, clamp} = require 'zooniverse/util'

  TEMPLATE = require 'views/SpectrogramPlayer'

  class SpectrogramPlayer extends Spine.Controller
    image: ''
    audio: ''

    keySeek: 200

    className: 'spectrogram-player'
    template: TEMPLATE

    sound: null
    seeking: false
    wasPlaying: false

    events:
      'mousedown .seek': 'seekStart'
      'click .controls .play': 'play'
      'click .controls .pause': 'pause'
      'keydown': 'keyDown'

    elements:
      '.spectrogram img': 'spectrogram'
      '.seek-line': 'seekLine'
      '.seek .track': 'track'
      '.seek .fill': 'fill'
      '.seek .thumb': 'thumb'

    constructor: ->
      super
      @html @template
      @el.attr tabindex: 0

      @setImage @image if @image
      @setAudio @audio if @audio

    delegateEvents: =>
      super

      doc = $(document)
      doc.on 'mousemove', @seekMove
      doc.on 'mouseup', @seekEnd

    setImage: (@image) =>
      @spectrogram.attr src: @image

    setAudio: (@audio) =>
      @el.removeClass 'loaded'

      @sound?.destruct()

      soundManager.onready =>
        @sound = soundManager.createSound
          id: "AUDIO_#{Math.floor Math.random() * 9999}"
          url: @audio

          whileloading: @soundLoading
          onload: @soundLoaded
          onplay: @soundPlayed
          whileplaying: @soundPlaying
          onpause: @soundPaused
          onfinish: @soundFinished

    soundLoading: =>
      @el.addClass 'loading'

    soundLoaded: =>
      @el.removeClass 'loading'
      @el.addClass 'loaded'

    soundPlayed: =>
      @el.addClass 'playing'

    soundPlaying: =>
      finishedPercent = "#{(@sound.position / @sound.duration) * 100}%"
      @seekLine.css left: finishedPercent
      @fill.css width: finishedPercent
      @thumb.css left: finishedPercent

    soundPaused: =>
      @el.removeClass 'playing'

    soundFinished: =>
      @soundPaused()
      delay 500, =>
        @sound.setPosition 0
        @soundPlaying()

    play: =>
      @sound.play()

    pause: =>
      @sound.pause()

    isPlaying: =>
      @sound.playState is 1 and not @sound.paused

    seekStart: (e) =>
      @wasPlaying = @isPlaying()
      @pause()

      @seeking = true
      @el.addClass 'seeking'

      @seekMove e

    seekMove: (e) =>
      return if not @seeking

      targetX = e.pageX - @track.offset().left
      percent = clamp targetX / @track.width()

      @sound.setPosition percent * @sound.duration
      @soundPlaying()

    seekEnd: (e) =>
      return if not @seeking

      @seeking = false
      @el.removeClass 'seeking'

      @play() if @wasPlaying

    SPACE = 32
    LEFT = 37
    RIGHT = 39
    keyDown: (e) =>
      return unless e.which in [SPACE, LEFT, RIGHT]

      e.preventDefault()

      switch e.which
        when SPACE
          if @isPlaying() then @pause() else @play()

        when LEFT
          @sound.setPosition clamp @sound.position - @keySeek, min: 0, max: @sound.duration
          @soundPlaying()

        when RIGHT
          @sound.setPosition clamp @sound.position + @keySeek, min: 0, max: @sound.duration
          @soundPlaying()

    release: =>
      @sound?.destruct()
      super

  module.exports = SpectrogramPlayer
