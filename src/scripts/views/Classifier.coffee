define (require, exports, module) ->
  module.exports = """
    <div class="interface">
      <div class="player">
        <!--Insert player here-->
      </div>

      <div class="controls">
        <div class="decision-tree">
          <!--Insert decision tree here-->
        </div>

        <div class="finished">
          <button class="next-subject">Next clip</button>
        </div>

        <div class="summary">
          <div class="favorite">
            <div class="create"><button>Mark as a favorite</button></div>
            <div class="destroy">Favorite added! <button>Undo</button></div>
          </div>

          <div class="followup">
            <div>Would you like to discuss this sound on Talk before moving on?</div>
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
