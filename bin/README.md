Bat Detective scripts
=====================

**NOTE: These tools will break on weird filenames.**

Try `rename --sanitize *.wav` first.

Dependencies
------------

On a Mac with Homebrew...

    brew install rename lame sox imagemagick

Otherwise...

* <http://plasmasturm.org/code/rename/>
* <http://lame.sourceforge.net/>
* <http://sox.sourceforge.net/>
* <http://www.imagemagick.org/script/index.php>

Convert audio to MP3
--------------------

Requires `lame`.

    convertaudio *.wav

Split a long audio at silences
------------------------------

Requires `sox`.

    split some_file.wav

Generate spectrograms for files
-------------------------------

Requires `imagemagick` and `sox`.

    spectrogram *.wav
