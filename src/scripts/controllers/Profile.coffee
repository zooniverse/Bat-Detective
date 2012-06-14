define (require, exports, module) ->
  $ = require 'jQuery'

  BaseProfile = require 'zooniverse/controllers/Profile'
  TEMPLATE = require 'views/Profile'

  class Profile extends BaseProfile
    template: TEMPLATE

    map: null

    elements: $.extend
      '.map': 'mapContainer'
      BaseProfile::elements

  module.exports = Profile
