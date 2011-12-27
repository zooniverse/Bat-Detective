class Widget extends Spine.Controller
	rootClass: ''
	template: ''

	mouseIsDown: null # The x and y where the mouse was downed.
	motion: # Positions updated when the mouse moves.
		relative:
			x: NaN
			y: NaN
		absolute:
			x: NaN
			y: NaN

	constructor: ->
		super
		@el.on 'mousedown', @onMouseDown
		$(document).on 'mousemove', @onMouseMove
		$(document).on 'mouseup', @onMouseUp

	render: =>
		@html(@template)
		@el.addClass(@rootClass)

	onMouseDown: (e) =>
		return if e.target.nodeName.toUpperCase() is 'SELECT'

		e.preventDefault()

		@mouseIsDown =
			x: e.clientX - @el.offset().left
			y: e.clientY - @el.offset().top
		
		@_updateMotion(e)

	onMouseMove: (e) =>
		if @mouseIsDown then @onDrag(e)

	onDrag: (e) =>
		@_updateMotion(e)

	_updateMotion: (e) =>
		x = (e.clientX - @el.offset().left) / @el.width()
		y = (e.clientY - @el.offset().top) / @el.height()

		{min, max} = Math

		@motion =
			relative:
				x: (e.clientX - @el.offset().left) - @mouseIsDown.x
				y: (e.clientY - @el.offset().top) - @mouseIsDown.y
			absolute:
				x: min(max(x, 0), 1)
				y: min(max(y, 0), 1)

	onMouseUp: (e) =>
		@mouseIsDown = null

	set: (property, value) =>
		if typeof property is 'object'
			for nestedProperty, nestedValue of property
				@set(nestedProperty, nestedValue)
		else if @["set_#{property}"]?
			@["set_#{property}"](value)
		else
			@[property] = value

	get: (property, passThrough...) =>
		@["get_#{property}"]?(passThrough...) || @[property]


class SoundSelection extends Widget
	start: NaN
	end: NaN

	frequencyRange: null

	toSet: ''
	originalWidth: NaN

	elements:
		'.start-handle': 'startHandle'
		'.end-handle': 'endHandle'

	rootClass: 'sound-selection'
	template: '''
		<div class="start-handle"></div>
		<div class="end-handle"></div>
	'''

	onMouseDown: (e) =>
		super

		@toSet = if e.target is @el[0]
			'center'
		else if e.target is @startHandle[0]
			'start'
		else if e.target is @endHandle[0]
			'end'
		
		@originalWidth = @el.width()

	onDrag: (e) =>
		super
		if @toSet then @set(@toSet, @frequencyRange.motion.absolute.x)

	set_start: (value) =>
		@start = value
		@log "Setting start to #{value}"
		@el.css('left', "#{value * 100}%")
		@el.css('width', "#{@originalWidth - @frequencyRange.motion.relative.x}")

	set_center: (value) =>
		@log "Setting center to #{value}"
		halfSize = (@end - @start) / 2
		@set('start', value - halfSize)
		@set('end',  value + halfSize)

	set_end: (value) =>
		@end = value
		@log "Setting end to #{value}"
		@el.width("#{(value - (@start || 0)) * 100}%")

	get_value: =>
		out =
			start: @frequencyRange.annotator.toTime(@start)
			end: @frequencyRange.annotator.toTime(@end)


class FrequencyRange extends Widget
	high: NaN
	low: NaN
	type: ''

	annotator: null

	toSet: '' # What property to change during drag, depending on the target
	originalHeight: NaN

	elements:
		'.high-handle': 'highHandle'
		'.low-handle': 'lowHandle'
		'.drag-handle': 'dragHandle'
		'.controls': 'controls'
		'.type': 'typeSelect'
		'.time-track': 'timeTrack'

	sounds: []

	rootClass: 'frequency-selection'
	template: '''
		<div class="drag-handle">
			<select class="type">
				<option value="UNKNOWN">What is this?</option>
				<option value="BAT">Bat</option>
				<option value="INSECT">Insect</option>
				<option value="MACHINE">Machine</option>
			</select>
		</div>

 		<div class="controls">
			<button class="delete">X</button>
 		</div>

		<div class="time-track"></div>

		<div class="high-handle"></div>
 		<div class="low-handle"></div>
	'''

	events:
		'change .type': 'typeChanged'
		'click .delete': 'release'

	constructor: ->
		super
		@sounds = []

	onMouseDown: (e) =>
		super

		@toSet = if e.target is @dragHandle[0] or e.target is @controls[0]
			'center'
		else if e.target is @highHandle[0]
			'high'
		else if e.target is @lowHandle[0]
			'low'
		else if e.target is @timeTrack[0]
			clickX = (e.clientX - @el.offset().left) / @timeTrack.width()
			@createSound(clickX)
			''

		@originalHeight = @el.height()

	onDrag: (e) =>
		super
		if @toSet then @set(@toSet, @annotator.motion.absolute.y)

	set_high: (value) =>
		@high = value
		@el.css('top', "#{value * 100}%")
		@el.css('height', "#{@originalHeight - @annotator.motion.relative.y}")

	set_center: (value) =>
		halfSize = (@low - @high) / 2
		@set('high', value - halfSize)
		@set('low',  value + halfSize)

	set_low: (value) =>
		@low = value
		@el.height("#{(value - @high || 0) * 100}%")

	createSound: (center) =>
		sound = new SoundSelection(frequencyRange: @)
		sound.render()
		sound.appendTo(@timeTrack)

		sound.set('start', center)
		sound.set('end', center + 0.1)

		@sounds.push(sound)

	typeChanged: (e) =>
		@type = @typeSelect.val()
		@el.removeClass('bat insect machine')
		@el.addClass(@typeSelect.val().toLowerCase())

	release: =>
		for sound in @sounds
			sound.release()
		super

	get_value: =>
		out =
			type: @type
			high: @annotator.toHertz(@high)
			low: @annotator.toHertz(@low)

		out.sounds = for sound in @sounds
			sound.get('value')

		out


class window.Annotator extends Widget
	# The highest and lowest frequency, in Hz (I guess)
	high: 100
	low: 50

	# The start and ending time for the sample, in milliseconds
	start: 0
	end: 3000

	value: null

	ranges: []

	rootClass: 'audio-annotator'

	constructor: ->
		super
		@ranges = []

	onMouseDown: (e) =>
		super

		if e.target is @el[0]
			clickY = (e.clientY - @el.offset().top) / @el.height()
			@createRange(clickY)

	createRange: (centerPoint) =>
		@log "Creating range at #{centerPoint}"

		range = new FrequencyRange(annotator: @)
		range.render()
		range.appendTo(@el)

		range.set('high', centerPoint - 0.05)
		range.set('low', centerPoint + 0.05)

		@ranges.push(range)

	release: =>
		for range in @ranges
			range.release()
		super

	toHertz: (outOfOne) =>
		((1 - outOfOne) * (@high - @low)) + @low

	toTime: (outOfOne) =>
		(outOfOne * (@end - @start)) + @start

	get_value: =>
		out = for range in @ranges
			range.get('value')
