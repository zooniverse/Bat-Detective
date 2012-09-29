$ = window.jQuery
soundManager = window.soundManager

delay = (duration, callback) ->
  if typeof duration is 'function'
    callback = duration
    duration = 1

  setTimeout callback, duration

clamp = (n, {min, max} = {min: 0, max: 1}) ->
  Math.min Math.max(n, min), max

wordsOnly = (string) ->
  string.replace /\W/g, ''

TEMPLATE = '''
  <div class="spectrogram">
    <img />
    <div class="seek-line"></div>
  </div>

  <div class="seek">
    <div class="track">
      <div class="fill"></div>
      <div class="thumb"></div>
    </div>
  </div>

  <div class="controls">
    <button class="play">&#9654;</button>
    <button class="pause">&#10073;&#10073;</button>
  </div>
'''

class SpectrogramPlayer
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

  constructor: (params = {}) ->
    @[property] = value for own property, value of params

    @el ||= $("<div class='#{@className}'></div>")
    @el = $(@el)

    @el.html @template
    @el.attr tabindex: 0

    @delegateEvents()
    @refreshElements()

    @setImage @image if @image
    @setAudio @audio if @audio

  delegateEvents: ->
    for eventString, method of @events
      eventParts = eventString.split(/^(\w+)\s/)[1..]
      @el.on eventParts..., @[method]

    doc = $(document)
    doc.on 'mousemove', @seekMove
    doc.on 'mouseup', @seekEnd

  refreshElements: ->
    @[key] = @el.find selector for selector, key of @elements

  setImage: (@image) ->
    @spectrogram.attr src: @image

  setAudio: (@audio) ->
    @el.removeClass 'loaded'

    if @sound?
      @sound.pause()
      @sound.setPosition 0
      @soundPlaying()
      @sound.destruct()

    soundManager.onready =>
      @sound = soundManager.createSound
        id: wordsOnly @audio
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

$(document).on 'click', '[data-play-audio]', ({currentTarget}) ->
  id = wordsOnly $(currentTarget).attr 'data-play-audio'
  sound = soundManager.getSoundById id
  sound.play()

window.SpectrogramPlayer = SpectrogramPlayer
