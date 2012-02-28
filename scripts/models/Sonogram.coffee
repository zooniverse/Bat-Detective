Spine = require 'Spine'

class Clip extends Spine.Model
	@configure 'Clip', 'start', 'end'
	@belongsTo 'sound', Sound

	start: NaN
	end: NaN

class Sound extends Spine.Model
	@configure 'Sound', 'high', 'low', 'maker', 'type'
	@hasMany 'clips', Clip
	@belongsTo 'sonogram', Sonogram

	high: NaN # 75000
	low: NaN # 50000

	maker: '' # "Bat" or "insect" or "machine"
	type: '' # "Social" or "searching" or "feeding"

class Sonogram extends Spine.Model
	@configure 'Sonogram', 'image', 'mp3', 'oga', 'location', 'environment', 'datetime'
	@hasMany 'sounds', Sound

	image: '' # "/path/to/image.jpg"

	mp3: '' # "/path/to/audio.mp3"
	oga: '' # "/path/to/audio/oga"

	location: '' # "United Kingdom"
	environment: '' # "Urban area"
	datetime: NaN # 1327529045883

exports = Sonogram
