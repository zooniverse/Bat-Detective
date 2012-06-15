define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  template = require 'views/FieldGuide'

  SpectrogramPlayer = require 'controllers/SpectrogramPlayer'

  class FieldGuide extends Spine.Controller
    className: 'field-guide'
    template: template

    constructor: ->
      super
      @html @template

      for container in @el.find '.sample'
        container = $(container)
        audio = container.find('[data-audio-src]').attr 'data-audio-src'
        image = container.find('img').attr 'src'

        new SpectrogramPlayer {el: container, image, audio}

  module.exports = FieldGuide
