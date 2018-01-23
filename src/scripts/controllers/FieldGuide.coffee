define (require, exports, module) ->
  Spine = require 'Spine'
  $ = window.jQuery

  template = require 'views/FieldGuide'

  Pager = require 'zooniverse/controllers/Pager'
  Map = require 'zooniverse/controllers/Map'
  SpectrogramPlayer = require 'controllers/SpectrogramPlayer'

  class FieldGuide extends Spine.Controller
    className: 'field-guide'
    template: template

    events:
      'click button[name="play-visible"]': 'playVisibleSample'

    constructor: ->
      super
      @html @template

      for pageContainer in @el.find('[data-page]').parent()
        new Pager el: pageContainer

      for container in @el.find '.sample'
        container = $(container)
        audio = container.find('[data-audio-src]').attr 'data-audio-src'
        image = container.find('img').attr 'src'

        new SpectrogramPlayer {el: container, image, audio}

    playVisibleSample: =>
      @el.find('.spectrogram-player:visible .play').click()

  module.exports = FieldGuide
