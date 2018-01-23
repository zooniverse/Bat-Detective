define (require, exports, module) ->
  $ = require 'jQuery'
  {remove, delay} = require 'zooniverse/util'

  class Route
    @routes: []
    @lastCheckedHash = '' # Used for replacing ellipses

    @checkHash: (hash) =>
      # Slice off "#!" from the hash.
      hash = location.hash.slice 2 unless typeof hash is 'string'

      # Ellipses are replaced with whatever segment is currently in that position.
      if ~location.hash.indexOf '...'
        location.hash = @replaceEllipses location.hash, @lastCheckedHash
        return

      for route in @routes
        params = route.test hash
        route.handler params... if params?

      @lastCheckedHash = hash

    @replaceEllipses: (hash) ->
      hashSegments = hash.split '/'
      pathSegments = @lastCheckedHash.split '/'

      for hashSegment, i in hashSegments
        hashSegments[i] = pathSegments[i] if hashSegment is '...'

      hashSegments.join '/'

    path: '' # Like "/foo/:bar"
    handler: null

    constructor: (@path, @handler) ->
      @constructor.routes.push @

      # Sort by number of segments to maintain hierarchy.
      @constructor.routes.sort (a, b) ->
        a.path.split('/').length > b.path.split('/').length

    test: (hash) =>
      pathSegments = @path.split '/'
      hashSegments = hash.split '/'

      # The hash must be as long or longer than the path.
      return unless hashSegments.length >= pathSegments.length

      params = []
      for pathSegment, i in pathSegments
        if pathSegment.charAt(0) is ':'
          params.push hashSegments[i]
        else if hashSegments[i] is pathSegments[i]
          continue
        else
          return # Not a match

      params

    destroy: =>
      remove @, from: @constructor.routes

    $(window).on 'hashchange', @checkHash
    $ => delay 250, @checkHash

  module.exports = Route
