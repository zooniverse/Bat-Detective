define (require, exports, module) ->
  module.exports = '''
    <div class="login-form"></div>
    <div class="profile">
      <div class="map"></div>

      <div class="info">
        <header>
          <h2>Hi <span class="username">Zooniverse user</span>!</h2>
          <p>Not <span class="username">Zooniverse user</span>? <a href="#sign-out" class="sign-out">Sign in with your own Zooniverse account.</a></p>
        </header>

        <div class="favorites">
          <h3>My favourites</h3>
          <p class="none">You don't have any favourites.</p>
          <ul></ul>
        </div>
      </div>

      <div class="stats">
        <section class="recents">
          <ul></ul>
        </section>

        <section class="findings">
          <h3>My findings</h3>

          <div class="scenes">
            <div class="count value">0</div>
            <div class="description">Scenes investigated</div>
          </div>
          <div class="bats">
            <div class="count value">0</div>
            <div class="description">Bat sounds classified</div>
          </div>
          <div class="insects">
            <div class="count value">0</div>
            <div class="description">Insect sounds classified</div>
          </div>
          <div class="machines">
            <div class="count value">0</div>
            <div class="description">Mechanical noises classified</div>
          </div>
        </section>
      </div>
    </div>
  '''
