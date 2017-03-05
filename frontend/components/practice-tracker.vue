<template>
  <div class="container">
    <div class="row">
      <div class="header text-center">Chord Practice</div>
    </div>
    <div class="row">
      <div class="text-center">Nav bar</div>
    </div>
    <div class="row">
      <div class="col-4">
        <div class="chord-list library" @dragover.prevent @drop="drop">
          <h6>Chord Library</h6>
          <ul class="list-group">
            <li class="list-group-item list-group-item-action" v-for="chord in allChords" draggable="true" @dragstart="dragStart">
              <fret-board boardSize="tiny" :chord="chord"></fret-board>
            </li>
          </ul>
        </div>
      </div>
      <div class="col-4">
        <div class="chord-list mine" @dragover.prevent @drop="drop">
          <h6>My Chords</h6>
          <ul class="list-group">
            <li class="list-group-item list-group-item-action" v-for="chord in myChords" draggable="true" @dragstart="dragStart">
              <fret-board boardSize="tiny" :chord="chord"></fret-board>
            </li>
          </ul>
        </div>
      </div>
      <div class="col-4">
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

 export default {
   name: 'practice-tracker',
   data() {
     return {
       allChords: [],
       myChords: []
     }
   },
   methods: {
     drop: function(evt) {
       let chordName = evt.dataTransfer.getData("chord");
       let targetList, sourceList;
       if (evt.dataTransfer.getData("targetList") === "mine") {
         targetList = this.myChords;
         sourceList = this.allChords;
       } else {
         sourceList = this.myChords;
         targetList = this.allChords;
       }
       for (let i = 0; i < sourceList.length; i++) {
         let chord = sourceList[i];
         if (chord.name === chordName) {
           targetList.push(chord);
           sourceList.splice(i, 1);
           break;
         }
       }
       targetList.sort(sortByName);
       sourceList.sort(sortByName);
     },
     dragStart: function(evt) {
       evt.dataTransfer.effectAllowed = "copy";
       let chordName = evt.currentTarget.querySelector(".fretboard").dataset.name;
       if (evt.currentTarget.parentElement.parentElement.classList.contains("library")) {
         evt.dataTransfer.setData("targetList", "mine");
       } else {
         evt.dataTransfer.setData("targetList", "library");
       }
       evt.dataTransfer.setData("chord", chordName);
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
