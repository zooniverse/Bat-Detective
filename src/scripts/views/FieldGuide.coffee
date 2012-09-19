define (require, exports, module) ->
  module.exports = '''
    <div class="details">
      <nav>
        <ul>
          <li><a href="#!/classify/bat-calls">Bat calls</a></li>
          <li><a href="#!/classify/insect-noise">Insect noises</a></li>
          <li><a href="#!/classify/machine-noise">Mechanical noises</a></li>
          <li><a href="#!/classify/context">Context</a></li>
        </ul>
      </nav>

      <section data-page="bat-calls" class="active">
        <div class="column">
          <div data-page="searching" class="active">
            <div data-page="vertical-hockey-stick" class="active sample">
              <span data-audio-src="examples/audio/bat-searching-vertical-hockey-stick.mp3"></span>
              <img src="examples/images/bat-searching-vertical-hockey-stick.jpg" class="framed" />
            </div>

            <div data-page="horizontal-hockey-stick" class="sample">
              <span data-audio-src="examples/audio/bat-searching-horizontal-hockey-stick.mp3"></span>
              <img src="examples/images/bat-searching-horizontal-hockey-stick.jpg" class="framed" />
            </div>
            <div data-page="vertical-line" class="sample">
              <span data-audio-src="examples/audio/bat-searching-vertical-line.mp3"></span>
              <img src="examples/images/bat-searching-vertical-line.jpg" class="framed" />
            </div>
            <div data-page="plateau" class="sample">
              <span data-audio-src="examples/audio/bat-searching-plateau.mp3"></span>
              <img src="examples/images/bat-searching-plateau.jpg" class="framed" />
            </div>
          </div>

          <div data-page="feeding">
            <div data-page="buzz" class="active sample">
              <span data-audio-src="examples/audio/bat-feeding-buzz.mp3"></span>
              <img src="examples/images/bat-feeding-buzz.jpg" class="framed" />
            </div>
          </div>

          <div data-page="social">
            <div data-page="social" class="active sample">
              <span data-audio-src="examples/audio/bat-social.mp3"></span>
              <img src="examples/images/bat-social.jpg" class="framed" />
            </div>
          </div>
        </div>

        <div class="column">
          <nav>
            <ul>
              <li><a href="#!/classify/bat-calls/searching">Searching</a></li>
              <li><a href="#!/classify/bat-calls/feeding">Feeding</a></li>
              <li><a href="#!/classify/bat-calls/social">Social</a></li>
            </ul>
          </nav>

          <section data-page="searching" class="active">
            <h4>What it looks like</h4>
            <p>Spectrograms show a well defined pulse of sound, usually between 13KHz and 120KHz. There are usually a number of regularly spaced pulses making up a sequence. The shape of the pulse can range from:</p>
            <nav>
              <ul>
                <li><a href="#!/classify/bat-calls/searching/vertical-hockey-stick">Vertical hockey-stick shaped</a></li>
                <li><a href="#!/classify/bat-calls/searching/horizontal-hockey-stick">Flatter, more horizontal hockey-stick shape</a></li>
                <li><a href="#!/classify/bat-calls/searching/vertical-line">Thin vertical line</a></li>
                <li><a href="#!/classify/bat-calls/searching/plateau">Flat table or plateau shape</a></li>
              </ul>
            </nav>

            <h4>What it sounds like</h4>
            <p>Searching calls can sound like a chirp, a squeak or an airy whistle.</p>
          </section>

          <section data-page="feeding">
            <h4>What it looks like</h4>
            <p>On the spectrogram you can see pulses getting closer and closer together, with the lines getting shorter and shorter.</p>
            <nav>
              <ul>
                <li><a href="#!/classify/bat-calls/feeding/buzz">Buzz-shaped</a></li>
              </ul>
            </nav>

            <h4>What it sounds like</h4>
            <p>These sound like normal bat calls but the calls get closer and closer together until they terminate abruptly.</p>
          </section>

          <section data-page="social">
            <h4>What it looks like</h4>
            <p>The spectrogram may show "V" shaped and tick shaped calls.</p>
            <nav>
              <ul>
                <li><a href="#!/classify/bat-calls/social/social">Social call example</a></li>
              </ul>
            </nav>

            <h4>What it sounds like</h4>
            <p>These sound like bat calls but with trills, and they're much closer together than normal bat calls. They may also have a different pitch than normal calls.</p>
          </section>
        </div>
      </section>

      <section data-page="insect-noise">
        <div class="column">
          <div data-page="distinct-pulse" class="active sample">
            <span data-audio-src="examples/audio/insect-distinct-pulse.mp3"></span>
            <img src="examples/images/insect-distinct-pulse.jpg" class="framed" />
          </div>
          <div data-page="car-alarm" class="sample">
            <span data-audio-src="examples/audio/insect-car-alarm.mp3"></span>
            <img src="examples/images/insect-car-alarm.jpg" class="framed" />
          </div>
          <div data-page="messy" class="sample">
            <span data-audio-src="examples/audio/insect-messy.mp3"></span>
            <img src="examples/images/insect-messy.jpg" class="framed" />
          </div>
        </div>

        <div class="column">
          <section>
            <h4>What it looks like</h4>
            <p>The spectrogram can have fast evenly spaced pulses near the bottom, much closer together than bat calls, or it might look like messy background noise in which you can hear distinct sounds. </p>
            <nav>
              <ul>
                <li><a href="#!/classify/insect-noise/distinct-pulse">Distinct pulse</a></li>
                <li><a href="#!/classify/insect-noise/car-alarm">Like a car alarm</a></li>
                <li><a href="#!/classify/insect-noise/messy">Messy spectrogram</a></li>
              </ul>
            </nav>

            <h4>What it sounds like</h4>
            <p>These sound like a rattling, a buzzing, or like a car alarm.</p>
          </section>
        </div>
      </section>

      <section data-page="machine-noise">
        <div class="column">
          <div data-page="car" class="active sample">
            <span data-audio-src="examples/audio/machine-car.mp3"></span>
            <img src="examples/images/machine-car.jpg" class="framed" />
          </div>
          <div data-page="click" class="sample">
            <span data-audio-src="examples/audio/machine-click.mp3"></span>
            <img src="examples/images/machine-click.jpg" class="framed" />
          </div>
          <div data-page="horizontal" class="sample">
            <span data-audio-src="examples/audio/machine-horizontal.mp3"></span>
            <img src="examples/images/machine-horizontal.jpg" class="framed" />
          </div>
          <div data-page="vertical" class="sample">
            <span data-audio-src="examples/audio/machine-vertical.mp3"></span>
            <img src="examples/images/machine-vertical.jpg" class="framed" />
          </div>
        </div>

        <div class="column">
          <section>
            <h4>What it looks like</h4>
            <p>The spectrogram appears random with no regular patterns to the noise, and may have either vertical or horizontal lines.</p>
            <nav>
              <ul>
                <li><a href="#!/classify/machine-noise/car">Car background noise</a></li>
                <li><a href="#!/classify/machine-noise/click">Click</a></li>
                <li><a href="#!/classify/machine-noise/horizontal">Horizontal spectrogram</a></li>
                <li><a href="#!/classify/machine-noise/vertical">Vertical spectrogram</a></li>
              </ul>
            </nav>

            <h4>What it sounds like</h4>
            <p>These can sound like a click, a crackle or static noise, or something metallic like the sound of a workshop. Some may sound like listening out the window of a moving car.</p>
          </section>
        </div>
      </section>

      <section data-page="context">
        <div class="column">
          <div class="framed map image"></div>
        </div>

        <div class="column">
          <section class="location">
            <h3>Location</h3>
            <div class="field">Paris, France</div>
          </section>

          <section class="habitat">
            <h3>Habitat</h3>
            <div class="field">Urban</div>
          </section>

          <section class="date">
            <h3>Date</h3>
            <div class="field">February 25, 1984</div>
          </section>

          <section class="time">
            <h3>Time</h3>
            <div class="field">12:34pm</div>
          </section>
        </div>
      </section>
    </div>
  '''