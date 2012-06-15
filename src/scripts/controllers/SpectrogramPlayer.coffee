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

      @setSources {@image, @audio}

    delegateEvents: =>
      super

      doc = $(document)
      doc.on 'mousemove', @seekMove
      doc.on 'mouseup', @seekEnd

    setSources: ({@image, @audio}) =>
      @spectrogram.attr src: @image

      @el.removeClass 'loaded'

      @sound?.destruct()

      soundManager.onready =>
        @sound = soundManager.createSound
          id: @audio.replace /\W+/g, '_'
          url: @audio

          whileloading: @playerLoading
          onload: @playerLoaded
          onplay: @playerPlayed
          whileplaying: @playerTimeUpdated
          onpause: @playerPaused
          onfinish: @playerFinished

    playerLoading: () =>
      @el.addClass 'loading'

    playerLoaded: =>
      @el.removeClass 'loading'
      @el.addClass 'loaded'

    playerPlayed: =>
      @el.addClass 'playing'

    playerTimeUpdated: =>
      finishedPercent = "#{(@sound.position / @sound.duration) * 100}%"
      @seekLine.css left: finishedPercent
      @fill.css width: finishedPercent
      @thumb.css left: finishedPercent

    playerPaused: =>
      @el.removeClass 'playing'

    playerFinished: =>
      @playerPaused()
      delay 500, =>
        @sound.setPosition 0
        @playerTimeUpdated()

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
      @playerTimeUpdated()

    seekEnd: (e) =>
      retrun if not @seeking

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
          @playerTimeUpdated()

        when RIGHT
          @sound.setPosition clamp @sound.position + @keySeek, min: 0, max: @sound.duration
          @playerTimeUpdated()

  module.exports = SpectrogramPlayer
