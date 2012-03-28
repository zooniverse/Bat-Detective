unless window.SM2_DEFER is true
	throw new Error 'window.SM2_DEFER must be true before loading SoundManager'

require 'lib/soundmanager/soundmanager2'

window.soundManager = new SoundManager()
window.soundManager.url = 'scripts/lib/soundmanager/swf'
window.soundManager.html5PollingInterval = 50
window.soundManager.beginDelayedInit()
window.soundManager.debugMode = false

exports = window.soundManager
