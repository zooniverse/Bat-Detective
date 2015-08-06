define (require, exports, module) ->
  Spine = require 'Spine'
  $ = require 'jQuery'

  config = require 'zooniverse/config'
  {remove} = require 'zooniverse/util'

  throw new Error 'zooniverse/Proxy needs config.apiHost' unless config.apiHost
  throw new Error 'zooniverse/Proxy needs config.proxyPath' unless config.proxyPath

  class Proxy extends Spine.Module
    @extend Spine.Events

    @iframe = $("<iframe src='#{config.apiHost}#{config.proxyPath}'></iframe>")
    @iframe.css display: 'none'
    @iframe.appendTo 'body'
    @external = @iframe.get(0).contentWindow

    # The iframe will post "ready" message when it loads.
    @ready: false

    # Requests added here and posted sequentially when the iframe is ready.
    @readyDaisyChain: [new $.Deferred]

    @requests:
      READY: new $.Deferred (deferred) =>
        deferred.always =>
          @ready = true
          # Kick off the daisy chain when the "ready" message comes.
          @readyDaisyChain[0].resolve()
          remove @readyDaisyChain[0], from: @readyDaisyChain

    # Headers to send along with requests (e.g. for authentication)
    @headers: {}

    @postMessage: (message) =>
      @external.postMessage JSON.stringify(message), config.apiHost

    @request: (type, url, data, done, fail) =>
      if typeof data is 'function'
        fail = done
        done = data
        data = null

      id = Math.floor Math.random() * 99999999
      deferred = new $.Deferred -> @then done, fail

      message = {id, type, url, data, @headers}

      if @ready
        @postMessage message
      else
        # Post this message after the last deferred in the chain has completed.
        @readyDaisyChain.slice(-1)[0].always =>
          @postMessage message
          remove deferred, from: @readyDaisyChain

        # Add this deferred to the end of the chain.
        @readyDaisyChain.push deferred

      @requests[id] = deferred
      deferred.always => delete @requests[id]

      deferred

    # Shortcuts
    @get: => @request 'get', arguments...
    @post: => @request 'post', arguments...
    @delete: => @request 'delete', arguments...
    @del: => @request 'delete', arguments...
    @getJSON: => @request 'getJSON', arguments...

    $(window).on 'message', ({originalEvent: e}) =>
      return unless e.origin is config.apiHost
      # Data will come back as:
      # {"id": "1234567890", "response": ["foo", "bar"]}
      {id, failure, response} = JSON.parse e.data
      @requests[id][not failure and 'resolve' or 'reject'] response

  module.exports = Proxy
