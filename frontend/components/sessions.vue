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
      <p class="p-0 m-0"><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#startPractice"><i class="fa fa-plus" aria-hidden="true"></i> Start</button></p>
    </div>
  </div>
  <div class="row mt-1">
    <div class="col-12">
      <div class="card">
        <h6 class="card-header">Practice Sessions</h6>
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
            <tr v-for="session in sessions">
              <td>{{format(session.created_at, 'YYYY-MM-DD HH:MM')}}</td>
              <td>{{session.numSwitches}}</td>
              <td>{{session.duration}}</td>
              <td>
                <div class="btn-group">
                  <button type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    Action
                  </button>
                  <div class="dropdown-menu dropdown-menu-right m-0 p-0">
                    <a class="dropdown-item m-1 p-0 h-25" href="#">Delete</a>
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="card-block" v-else>
          <div class="alert alert-info"><strong>Hey!</strong> You have no practice sessions yet. Why not <a href="#" @click="startSession" class="alert-link">start one?</a></div>
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
      }
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
    startSession: function(event) {
      Axios.post('/sessions', {session: this.newSession}).then(
        response => {
          alert("Started session: ", response);
        },
        error => {
          alert("Could not create session: ", error);
        }
      );
      return false;
    }
  },
  created() {
    Axios.get('/sessions.json').then( response => {
      this.sessions = response.data.sessions;
    }, error => {
    });
  }
}
</script>
