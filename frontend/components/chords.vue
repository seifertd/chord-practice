<template>
  <div class="container">
    <div class="row mt-1">
      <div class="col-12">
        <div class="card chord-list library">
          <h6 class="card-header">Chord Library</h6>
          <ul class="card-block list-group-horizontal">
            <li class="list-group-item list-group-item-action" v-for="chord in allChords" @click="swapChord" @touchStart="swapChord">
              <fret-board boardSize="tiny" :chord="chord" z-index="-1"></fret-board>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <p class="text-center m-0 p-0">
          <i class="fa fa-arrows-v" aria-hidden="true"></i>
        </p>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <div class="card chord-list mine">
          <h6 class="card-header">My Chords</h6>
          <ul class="card-block list-group-horizontal">
            <li class="list-group-item list-group-item-action" v-for="chord in myChords" @click="swapChord" @touchStart="swapChord">
              <fret-board boardSize="tiny" :chord="chord" z-index="-1"></fret-board>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        Other stuff here ...
      </div>
    </div>
    <div class="row">
      <div class="footer">Footer</div>
    </div>
  </div>
</template>
<script>
 import Axios from 'axios'

 const sortByName = (a, b) => {
   if ( a.name < b.name ) {
     return -1;
   }
   if ( a.name > b.name ) {
     return 1;
   }
   return 0;
 };

 const deleteChord = (array, chordName) => {
   for (let i = 0; i < array.length; i++) {
     let chord = array[i];
     if (chord.name === chordName) {
       array.splice(i, 1);
       return chord;
     }
   }
   return null;
 };

 export default {
   name: 'chords',
   data() {
     return {
       allChords: [],
       myChords: []
     }
   },
   methods: {
     swapChord: function(evt) {
       let chordName = evt.currentTarget.querySelector(".fretboard").dataset.name;
       let targetList, sourceList;
       if (evt.currentTarget.parentElement.parentElement.classList.contains("library")) {
         targetList = this.myChords;
         sourceList = this.allChords;
       } else {
         sourceList = this.myChords;
         targetList = this.allChords;
       }
       let chord = deleteChord(sourceList, chordName);
       if (chord) {
         targetList.push(chord);
         targetList.sort(sortByName);
         sourceList.sort(sortByName);
         Axios.put('/chords', {chords: this.myChords.map(chord => chord.name)}).then( response => {
         }, error => {
           alert("Could not save: ", error);
         });
       }
     }
   },
   created() {
     Axios.get('/chords.json').then( response => {
       this.allChords = response.data.chords;
       this.myChords = response.data.player.chords.map((chordName) => {
         return deleteChord(this.allChords, chordName);
       });
     }, error => {
     });
   }
 }
</script>
