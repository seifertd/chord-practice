<template>
<div class="container-fluid mt-5">
  <div class="row">
    <div class="col-12">
      <div v-if="!session">
        <i class="fa fa-spinner fa-spin"></i> Loading session ...
      </div>
      <div v-else class="card">
        <h6 class="card-header text-center">Date: {{format(session.createdAt, 'YYYY-MM-DD HH:MM')}}, Pairs Left: {{pairsLeft()}}</h6>
        <div class="card-block text-center carousel slide" id="practiceSession" data-ride="carousel" data-pause="true" data-interval="false">
          <div class="carousel-inner" role="listbox">
            <div class="carousel-item" v-for="(pair, idx) in session.pairs" :class="idx == 0 ? 'active' : ''">
              <div class="container-fluid align-items-center">
                <div class="row">
                  <div class="col-5">
                    <fret-board :boardSize="boardSize" :chord="pair.firstChord" z-index="-1"></fret-board>
                  </div>
                  <div class="col-2">
                    <i class="fa fa-exchange" style="font-size: 40px" aria-hidden="true"></i>
                  </div>
                  <div class="col-5">
                    <fret-board :boardSize="boardSize" :chord="pair.secondChord" z-index="-1"></fret-board>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="card-footer">
          <div class="alert alert-info" v-if="state == 'Ready'">
            <strong>Ready to start.</strong> Click start below to continue!
          </div>
          <div class="alert alert-warning" v-if="state == 'Complete'">
            <strong>Complete.</strong> This practice session is complete.
          </div>
          <div class="alert alert-success" v-if="state == 'Running' || state == 'Switching'">
            <strong>{{countDown}}</strong>&nbsp;&nbsp;{{message}}
          </div>
          <div class="alert alert-warning" v-if="state == 'Waiting'">
            <strong>{{countDown}}</strong>&nbsp;&nbsp;{{message}}
          </div>
          <div class="alert alert-info" v-if="state == 'Recording'">
            How many switches did you make? <input type="text" v-model="currentPair.switches" size="5"> <button type="submit" class="btn btn-primary" @click="recordSwitches()">Save</button>
          </div>
          <div class="text-center">
            <div class="btn-group">
              <button type="submit" class="btn btn-primary" @click="startSwitching()" v-if="state == 'Ready'">Start</button>
              <button type="submit" class="btn btn-primary" @click="startSwitching()" v-if="state == 'Running'">Continue</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</template>
<script>
import Axios from 'axios'
import format from 'date-fns/format'
export default {
  data() {
    return {
      session: null,
      boardSize: 'default',
      countDown: 3,
      message: "Get ready to start switching ...",
      currentPair: null,
      state: 'Ready'
    };
  },
  mounted() {
    let getBoardSize = () => {
      let windowWidth = $(window).width();
      if (windowWidth < 575) {
        return 'small';
      } else {
        return 'default';
      }
    };
    this.boardSize = getBoardSize();
    $(window).resize((evt) => {
      this.boardSize = getBoardSize();
    });
  },
  methods: {
    format,
    startSwitching() {
      this.currentPair = this.session.pairs.find(pair => !pair.complete);
      this.session.started = true;
      this.state = 'Waiting';
      setTimeout(this.incrementCountDown, 1000);
    },
    pairsLeft() {
      return this.session.pairs.reduce((sum, pair) => { return sum + (pair.complete ? 0 : 1); }, 0);
    },
    incrementCountDown() {
      this.countDown -= 1;
      if (this.countDown > 0) {
        setTimeout(this.incrementCountDown, 1000);
      } else {
        if (this.state == 'Waiting') {
          this.state = 'Switching';
          //this.countDown = this.session.duration * 60;
          this.countDown = 3;
          this.message = "Switch as fast as you can!"
          setTimeout(this.incrementCountDown, 1000);
        } else {
          this.state = 'Recording';
          this.currentPair.complete = true;
          this.countDown = 3;
          this.message = "Get ready to start switching ...";
        }
      }
    },
    recordSwitches() {
      if (this.session.pairs.every(pair => pair.complete)) {
        this.state = 'Complete';
        this.session.complete = true;
        Axios.put(`/sessions/${this.session.id}.json`, this.session).then( response => {
        }, error => {
        });
      } else {
        this.state = this.session.started ? 'Running' : 'Ready';
        $("#practiceSession").carousel('next');
      }
    }
  },
  beforeRouteEnter (to, from, next) {
    Axios.get(`/sessions/${to.params.id}.json`).then(
      function(response) {
        next(vm => { vm.session = response.data.session; });
      },
      function(err) {
        alert("Could not load practice: ", err);
        next(false);
      }
    );
  },
  watch: {
    $route () {
      this.session = null;
      Axios.get(`/sessions/${this.$route.params.id}.json`).then(
        function(response) {
          this.session = response.data.session;
          if (this.session.started) {
            this.state = "Running";
          } else if (this.session.complete) {
            this.state = "Complete";
          } else {
            this.state = "Ready";
          }
        },
        function(err) {
          alert("Could not load practice: ", err);
        }
      );
    }
  }
}
</script>
