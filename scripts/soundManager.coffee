require 'lib/soundmanager/script/soundmanager2'

# This must be in your markup before this module can be required:
# <script type="text/javascript">window.SM2_DEFER = true;</script>

window.soundManager = new SoundManager()
window.soundManager.url = 'scripts/lib/soundmanager/swf'
window.soundManager.preferFlash = false
window.soundManager.beginDelayedInit()

exports = window.soundManager
