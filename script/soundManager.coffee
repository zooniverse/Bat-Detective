@SM2_DEFER = true; # TODO: Will this build okay?

define (require) ->
	require '/lib/soundmanager/script/soundmanager2.js'
	@soundManager = new SoundManager()
	@soundManager.url = '/lib/soundmanager/swf'
	@soundManager.preferFlash = false
	@soundManager.beginDelayedInit()

	@soundManager
