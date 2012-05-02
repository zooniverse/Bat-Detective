Spine = require 'Spine'
$ = require 'jQuery'

Classification = require 'models/Classification'

class Subject extends Spine.Model
  @configure 'Subject', 'image', 'audio', 'latitude', 'longitude', 'location', 'habitat', 'captured'

  @projectId: '4fa0321854558f2fbf000002'
  @workflowId: '4fa0321854558f2fbf000003'

  @current: null

  @deserialize: (raw) ->
    id: raw.id
    image: raw.location.image
    audio: raw.location.audio
    latitude: raw.coords[0]
    longitude: raw.coords[1]
    location: raw.metadata.location
    habitat: raw.metadata.habitat
    captured: +(new Date raw.metadata.captured_at)

  @fetch: ->
    url = "http://localhost:3000/projects/#{@projectId}/workflows/#{@workflowId}/subjects"
    def = new $.Deferred

    @trigger 'fetching'
    $.getJSON url, (response) =>
      def.resolve @create @deserialize response[0]

    def.then (subject) =>
      @trigger 'fetch', subject

    def

  @setCurrent: (subject) ->
    @trigger 'change-current', subject

exports = Subject
