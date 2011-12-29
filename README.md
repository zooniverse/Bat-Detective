UI widget for annotating sonograms.

Requires CoffeeScript, jQuery, and Spine:

* ./coffee-script.js
* ./jquery.js
* ./spine/lib/spine.js

Load up index.html and drag down on the yellow box to highlight frequency ranges. You can move them by dragging the handle on the left. You can also set their type as "bat", "insect", or "machine".

Drag across a frequency range to highlight specific sounds in it.

This example annotator is available globally as `annotation`. Call `annotation.get('value')` in the console to see a JSON serialization of the frequency ranges and their types and sounds.
