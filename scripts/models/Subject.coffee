Spine = require 'Spine'
$ = require 'jQuery'

class Subject extends Spine.Model
  @configure 'Subject', 'zooniverseId', 'image', 'audio', 'latitude', 'longitude', 'location', 'habitat', 'captured'

  @server: 'http://localhost:3000'
  @projectId: '4fa0321854558f2fbf000002'
  @workflowId: '4fa0321854558f2fbf000003'

  @current: null

  @fromJSON: (raw) ->
    processed =
      id: raw.id
      zooniverseId: raw.zooniverse_id
      image: raw.location.image
      audio: raw.location.audio
      latitude: raw.coords[0]
      longitude: raw.coords[1]
      location: raw.metadata.location
      habitat: raw.metadata.habitat
      captured: +(new Date raw.metadata.captured_at)

    super processed

  @fetch: ->
    url = "#{@server}/projects/#{@projectId}/workflows/#{@workflowId}/subjects"
    def = new $.Deferred

    @trigger 'fetching'

    $.getJSON url, (response) =>
      def.resolve @fromJSON response[0]

    def.then (subject) =>
      @trigger 'fetch', subject

    def

  @setCurrent: (newCurrent) ->
    return if newCurrent is @current
    @current = newCurrent
    @trigger 'change-current', newCurrent

exports = Subject
