define (require, exports, module) ->
  module.exports = '''
    <div class="spectrogram">
      <img />
      <div class="seek-line"></div>
    </div>

    <div class="seek">
      <div class="track">
        <div class="fill"></div>
        <div class="thumb"></div>
      </div>
    </div>

    <div class="controls">
      <button class="play">&#9654;</button>
      <button class="pause">&#10073; &#10073;</button>
    </div>
  '''
