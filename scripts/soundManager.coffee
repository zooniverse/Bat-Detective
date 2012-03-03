require 'lib/soundmanager/script/soundmanager2'

unless window.SM2_DEFER is true
	console.log 'window.SM2_DEFER must be true before loading SoundManager'

window.soundManager = new SoundManager()
window.soundManager.url = 'scripts/lib/soundmanager/swf'
window.soundManager.preferFlash = false
window.soundManager.beginDelayedInit()

exports = window.soundManager
