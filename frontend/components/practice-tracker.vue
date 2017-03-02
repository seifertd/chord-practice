<template>
  <div>
    <h1>Chord Practice</h1>
    <div class="chord-list">
      <h5>Chord Library</h5>
      <ul>
        <li v-for="chord in allChords">
          <fret-board boardSize="tiny" :chord="chord"></fret-board>
        </li>
      </ul>
    </div>
    <div class="chord-list">
      <h5>My Chords</h5>
      <ul>
        <li v-for="chord in myChords">
          <fret-board boardSize="tiny" :chord="chord"></fret-board>
        </li>
      </ul>
    </div>
  </div>
  </div>
</template>
<script>
 import Axios from 'axios'

 export default {
   name: 'practice-tracker',
   data() {
     return {
       allChords: [],
       myChords: []
     }
   },
   created() {
     Axios.get('/chords.json').then( response => {
       this.allChords = response.data.chords;
     }, error => {
     });
   }
 }
</script>
