<template>
<div class="container">
  <div class="modal fade" id="startPractice" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Start a Practice</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <form>
            <div class="form-group">
              <label for="numberOfSwitches">Number of chord pairs</label>
              <select class="form-control" id="numberOfSwitches" v-model="newSession.numberOfSwitches">
                <option v-for="number in availableSwitches" :value="number">{{number}}</option>
              </select>
              <div class="form-check">
                <label clas="form-check-label">
                  <input class="form-check-input ml-1" type="checkbox" value="true" checked>
                  Choose a random selection
                </label>
              </div>
            </div>
            <div class="form-group">
              <label for="duration">Duration of each pair</label>
              <select class="form-control" id="duration" v-model="newSession.duration">
                <option v-for="duration in availableDurations" :value="duration">{{duration}}</option>
              </select>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" @click="startSession">Start</button>
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
  </div>
  <div class="row mt-1">
    <div class="col-12">
      <p class="p-0 m-0"><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#startPractice"><i class="fa fa-plus" aria-hidden="true"></i> Start New</button></p>
    </div>
  </div>
  <div class="row mt-1">
    <div class="col-12">
      <div class="card">
        <h6 class="card-header">Practice Sessions</h6>
        <div class="card-block" v-if="error">
          <error :error="error" />
        </div>
        <table class="table table-sm table-bordered card-block" v-if="hasSessions">
          <thead class="thead-default">
            <tr>
              <th>Date</th>
              <th>Number of Switches</th>
              <th>Duration</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="session in sessions" :data-session-id="session.id">
              <td>{{format(session.createdAt, 'YYYY-MM-DD')}}</td>
              <td>{{session.pairs.length}}</td>
              <td>{{session.duration}}</td>
              <td>
                <div class="btn-group" role="group" aria-label="Actions">
                  <button type="button" class="btn btn-primary btn-sm" v-if="!session.done" @click="openSession">Start</button>
                  <button type="button" class="btn btn-danger btn-sm" @click="deleteSession">Delete</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="card-block" v-else-if="!error">
          <div class="alert alert-info"><strong>Hey!</strong> You have no practice sessions yet. Why not <a href="#" data-toggle="modal" data-target="#startPractice" class="alert-link">start one?</a></div>
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
  name: 'sessions',
  data() {
    return {
      sessions: [],
      newSession: {
        numberOfSwitches: 10,
        duration: 1
      },
      error: null
    }
  },
  computed: {
    hasSessions: function() {
      return this.sessions && this.sessions.length > 0;
    },
    availableSwitches: function() {
      return [10,5,6,7,8,9,10,11,12,13,14,15];
    },
    availableDurations: function() {
      return [1,2,3];
    }
  },
  methods: {
    format,
    deleteSession: function(event) {
      if (confirm("Are you sure?")) {
        let sessionId = $(event.target).closest("tr")[0].dataset.sessionId;
        let mySessions = this.sessions;
        let sessionIdx = mySessions.findIndex(session => session.id == sessionId);
        if (sessionIdx >= 0) {
          Axios.delete(`/sessions/${sessionId}.json`).then(
            function(response) {
              mySessions.splice(sessionIdx,1);
            },
            function(error) {
              this.error = { heading: "Error deleting session!", message: error.toString() };
            }
          );
        }
      }
      return false;
    },
    openSession: function(event) {
      let sessionId = $(event.target).closest("tr")[0].dataset.sessionId;
      window.location.href ="/sessions/" + sessionId;
    },
    startSession: function(event) {
      var mySessions = this.sessions;
      Axios.post('/sessions', {session: this.newSession, format: 'json'}).then(
        function(response) {
          mySessions.push(response.data.session);
          $("#startPractice").modal('hide');
        },
        function(error) {
          this.error = { heading: "Error starting session!", message: error.toString() };
        }
      );
      return false;
    }
  },
  created() {
    Axios.get('/sessions.json').then( response => {
      this.sessions = response.data.sessions;
    }, error => {
      this.error = { heading: "Error loading page!", message: error.toString() };
    });
  }
}
</script>
