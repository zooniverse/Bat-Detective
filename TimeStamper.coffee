class Widget extends Spine.Controller
	rootClass: '' # Will be applied to @el
	template: '' # Will be used to populate @el

	# The x and y where the mouse was downed.
	mouseIsDown: null
	
	# Positions updated when the mouse moves.
	motion:
		relative:
			x: NaN
			y: NaN
		absolute:
			x: NaN
			y: NaN

	constructor: ->
		super

		@render()

		@el.on 'mousedown', @onMouseDown

		# Some mouse events are better delegated to the document
		$(document).on 'mousemove', @onMouseMove
		$(document).on 'mouseup', @onMouseUp

	# Fill in the template and add the rootClass.
	render: =>
		@html(@template)
		@el.addClass(@rootClass)

	onMouseDown: (e) =>
		# Preventing default of a <select> mousedown effectively disables it in Chrome.
		return if e.target.nodeName.toUpperCase() is 'SELECT'

		e.preventDefault()

		# Remember where the mouse went down so we can see how far it's moved.
		@mouseIsDown =
			x: e.clientX - @el.offset().left
			y: e.clientY - @el.offset().top
		
		@_updateMotion(e)

	onMouseMove: (e) =>
		if @mouseIsDown then @onDrag(e)

	# Fired when the mouse moves while it's down.
	onDrag: (e) =>
		@_updateMotion(e)

	_updateMotion: (e) =>
		{min, max} = Math

		x = (e.clientX - @el.offset().left) / @el.width()
		y = (e.clientY - @el.offset().top) / @el.height()

		@motion =
			relative:
				x: (e.clientX - @el.offset().left) - @mouseIsDown.x
				y: (e.clientY - @el.offset().top) - @mouseIsDown.y
			absolute:
				x: min(max(x, 0), 1)
				y: min(max(y, 0), 1)

	onMouseUp: (e) =>
		@mouseIsDown = null

	# Set property values, using a custom set_propertyName method if available.
	set: (property, value) =>
		if typeof property is 'object'
			# Set multiple properties at once.
			for nestedProperty, nestedValue of property
				@set(nestedProperty, nestedValue)
		else
			@["set_#{property}"]?(value) || @[property] = value

	# Allows for custom getters.
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
		<div class="sound-controls">
			<button class="delete-sound">x</button>
		</div>
		<div class="start-handle"></div>
		<div class="end-handle"></div>
	'''

	events:
		'click .delete-sound': 'release'

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
		return if value < 0 or value > 1

		@start = value
		@el.css('left', "#{value * 100}%")

	set_center: (value) =>
		newStart = @start + (@motion.relative.x / @frequencyRange.el.width())
		newEnd =   @end   + (@motion.relative.x / @frequencyRange.el.width())

		@log newStart, newEnd

		if newStart >= 0 and newEnd <= 1
			@set('start', newStart)
			@set('end',  newEnd)

	set_end: (value) =>
		return if value < 0 or value > 1

		@end = value
		@el.css('right', "#{(1 - value) * 100}%")

	get_value: =>
		out =
			start: @frequencyRange.annotator.toTime(@start)
			end: @frequencyRange.annotator.toTime(@end)

	release: =>
		# Remove this sound from its parent frequency's list.
		for sound, i in @frequencyRange.sounds when sound is @
			# Modify the frequency's sound list in a timeout so that its
			# release method doesn't modify the array it iterates over.
			index = i
			setTimeout(
				=> @frequencyRange.sounds.splice(index, 1)
				0
			)

		super


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

 		<div class="frequency-controls">
			<button class="delete-frequency">X</button>
 		</div>

		<div class="time-track"></div>

		<div class="high-handle"></div>
 		<div class="low-handle"></div>
	'''

	events:
		'change .type': 'typeChanged'
		'click .delete-frequency': 'release'

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
		@log 'High', value
		return if value < 0 or value > 1

		@high = value
		@el.css('top', "#{value * 100}%")

	set_center: (value) =>
		newHigh = @high + (@motion.relative.y / @annotator.el.height())
		newLow = @low + (@motion.relative.y / @annotator.el.height())

		if newHigh >= 0 and newLow <= 1
			@set('high', newHigh)
			@set('low',  newLow)

	set_low: (value) =>
		@log 'Low', value
		return if value < 0 or value > 1

		@low = value
		@el.css('bottom', "#{(1 - value) * 100}%")

	createSound: (center) =>
		sound = new SoundSelection(frequencyRange: @)
		sound.appendTo(@timeTrack)

		# Get the new sound's drag started
		sound.onMouseDown(
			clientX: center
			clientY: NaN
			target: sound.endHandle[0]
			preventDefault: ->
		)

		sound.set('start', center)
		sound.set('end', center + 0.05)

		@sounds.push(sound)

	typeChanged: (e) =>
		@type = @typeSelect.val()
		@el.removeClass('bat insect machine')
		@el.addClass(@typeSelect.val().toLowerCase())

	get_value: =>
		out =
			type: @type
			high: @annotator.toHertz(@high)
			low: @annotator.toHertz(@low)

		out.sounds = for sound in @sounds
			sound.get('value')

		out

	release: =>
		sound.release() for sound in @sounds

		for range, i in @annotator.ranges when range is @
			# Modify the annotator's range list in a timeout so that its
			# release method doesn't modify the array it iterates over.
			index = i # By the time the timeout fires i will be the array's length.
			setTimeout(
				=> @annotator.ranges.splice(index, 1)
				0
			)

		super


class window.Annotator extends Widget
	# The highest and lowest frequency, in Hz (probably)
	high: 100
	low: 50

	# The start and ending time for the sample, in milliseconds
	start: 0
	end: 3000

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
		range.appendTo(@el)

		# Get the new range's drag started
		range.onMouseDown(
			clientX: NaN
			clientY: centerPoint
			target: range.lowHandle[0]
			preventDefault: ->
		)

		range.set('high', centerPoint)
		range.set('low', centerPoint + 0.05)

		@ranges.push(range)

	release: =>
		range.release() for range in @ranges
		super

	# Convert a number between 0 and 1 to a frequency in this annotator's range.
	# The lower the input, the higher the frequency, so subtract from 1 first.
	toHertz: (outOfOne) =>
		((1 - outOfOne) * (@high - @low)) + @low

	# Convert a number between 0 and 1 to a time on this annotator's scale.
	toTime: (outOfOne) =>
		(outOfOne * (@end - @start)) + @start

	# JSON representation of the marked frequencies and their sounds
	get_value: =>
		out = for range in @ranges
			range.get('value')

		JSON.stringify(out)

	release: =>
		for range in @ranges
			range.release()

		super
