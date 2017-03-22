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
              <select class="form-control" id="numberOfSwitches">
                <option v-for="number in availableSwitches" :value="number">{{number}}</option>
              </select>
            </div>
            <div class="form-group">
              <label for="duration">Duration of each pair</label>
              <select class="form-control" id="duration">
                <option v-for="number in availableDurations" :value="number">{{number}}</option>
              </select>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary">Start</button>
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
  </div>
  <div class="row mt-1">
    <div class="col-12">
      <p class="text-right p-0 m-0"><button type="button" class="btn btn-primary" data-toggle="modal" data-target="#startPractice"><i class="fa fa-plus" aria-hidden="true"></i> Start</button></p>
    </div>
  </div>
  <div class="row mt-1">
    <div class="col-12">
      <div class="card">
        <h6 class="card-header">Practice Sessions</h6>
        <table class="table card-block" v-if="hasSessions">
          <tr>
            <th>Date</th>
            <th>Number of Switches</th>
            <th>Duration</th>
          </tr>
          <tr v-for="session in sessions">
            <th>{{session.createdAt}}</th>
            <th>{{session.numSwitches}}</th>
            <th>{{session.duration}}</th>
          </tr>
        </table>
        <div class="card-block" v-else>
          <p><strong>You have no practice sessions yet.</strong></p>
        </div>
      </div>
    </div>
  </div>
</div>
</template>
<script>
import Axios from 'axios'
export default {
  name: 'sessions',
  data() {
    return {
      sessions: []
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
  created() {
    Axios.get('/sessions.json').then( response => {
      this.sessions = response.data.sessions;
    }, error => {
    });
  }
}
</script>
