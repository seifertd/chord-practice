<template>
<div class="container-fluid mt-5">
  <div class="row">
    <div class="col-12 text-center">
      <div v-if="!session">
        <i class="fa fa-spinner fa-spin"></i> Loading session ...
      </div>
      <div v-else class="card">
        <h6 class="card-header">Date: {{format(session.createdAt, 'YYYY-MM-DD HH:MM')}}</h6>
        <ul class="card-block list-group-horizontal" style="background-color: #777;">
          <li class="list-group-item" v-for="(pair, idx) in session.pairs" :class="idx > 0 ? 'hidden' : ''">
            <div class="container-fluid align-items-center">
              <div class="row">
                <div class="col-5">
                  <fret-board boardSize="default" :chord="pair.firstChord" z-index="-1"></fret-board>
                </div>
                <div class="col-2">
                  <i class="fa fa-exchange" style="font-size: 40px" aria-hidden="true"></i>
                </div>
                <div class="col-5">
                  <fret-board boardSize="default" :chord="pair.secondChord" z-index="-1"></fret-board>
                </div>
              </div>
            </div>
          </li>
        </ul>
      </div>
      <form class="form-inline">
        <button type="submit" class="btn btn-primary" v-if="!session.completed && !session.started">Start</button>
        <button type="submit" class="btn btn-primary" v-if="!session.completed && session.started">Continue</button>
        <button type="submit" class="btn btn-danger">Delete</button>
      </form>
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
      boardSize: 'default'
    };
  },
  methods: {
    format
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
        },
        function(err) {
          alert("Could not load practice: ", err);
        }
      );
    }
  }
}
</script>
