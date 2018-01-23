define (require, exports, module) ->
  $ = require 'jQuery'

  class GoogleAnalytics
    @instance: null

    @track: (location) ->
      window._gaq.push ['_trackPageview', location || window.location.href]

    account: ''
    domain: ''

    constructor: ({@account, @domain}) ->
      throw new Error 'Google Analytics already instantiated' if @constructor.instance
      throw new Error 'No account for Google Analytics' unless @account
      throw new Error 'No domain for Google Analytics' unless @domain

      window._gaq ?= [
        ['_setAccount', @account]
        ['_setDomainName', @domain]
        ['_trackPageview']
      ]

      src = 'http://www.google-analytics.com/ga.js'
      src = src.replace 'http://www', 'https://ssl' if location.protocol is 'https:'
      $("<script src='#{src}'></script>").appendTo 'head'

      $(window).on 'hashchange', @constructor.track
      @constructor.track()

      @constructor.instance = @

  module.exports = GoogleAnalytics
