define (require, exports, module) ->
  module.exports = """
    <div class="interface">
      <!--This scale is inserted into the player after it's created.-->
      <!--TODO: Is this actually a linear scale?-->
      <div class="scale">
        <div class="axis">
          <div class="space"><div class="label">110 KHz</div></div>
          <div class="space"></div>
          <div class="space"></div>
          <div class="space"></div>
          <div class="space"><div class="label">83 KHz</div></div>
          <div class="space"></div>
          <div class="space"></div>
          <div class="space"></div>
          <div class="space"><div class="label">55 KHz</div></div>
          <div class="space"></div>
          <div class="space"></div>
          <div class="space"></div>
          <div class="space"><div class="label">28 KHz</div></div>
          <div class="space"></div>
          <div class="space"></div>
          <div class="space"></div>
          <div class="space"><div class="label">0 KHz</div></div>
        </div>
      </div>

      <div class="player">
        <!--Insert player here-->
      </div>

      <div class="controls">
        <ol class="instructions">
          <li>
            <p class="heading">Step 1</p>
            <p>Mark the frequency of a sound (vertically).</p>
          </li>

          <li>
            <p class="heading">Step 2</p>
            <p>Highlight any individual bits of sound (horizontally).</p>
          </li>

          <li>
            <p class="heading">Step 3</p>
            <p>Consult the field guide to identify the sound.</p>
          </li>

        </ol>

        <div class="decision-tree">
          <!--Insert decision tree here-->
        </div>

        <div class="finished">
          <button class="next-subject">Next sound</button>
        </div>

        <div class="summary">
          <div class="favorite">
            <div class="create"><button>Mark as a favourite</button></div>
            <div class="destroy"><p>Favourite added!</p><button>Undo</button></div>
          </div>

          <div class="talk">
            <p>Would you like to discuss this sound on Talk before moving on?</p>
            <button class="yes">Yes</button>
            <button class="no">No</button>
          </div>
        </div>
      </div>
    </div>

    <div class="field-guide">
      <!--Insert field guide here-->
    </div>
  """
