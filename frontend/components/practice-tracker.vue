<template>
  <div>
    <div class="bigone d-flex flex-column">
      <div class="header text-center p-3">Chord Practice</div>
      <div class="text-center p-2 mb-3">Nav bar</div>
      <div class="main d-flex">
        <div class="container-fluid d-flex">
          <div class="row">
            <div class="col-4 d-flex flex-column">
              <div class="chord-list library" @dragover.prevent @drop="drop">
                <h5>Chord Library</h5>
                <ul>
                  <li v-for="chord in allChords" draggable="true" @dragstart="dragStart">
                    <fret-board boardSize="tiny" :chord="chord"></fret-board>
                  </li>
                </ul>
              </div>
            </div>
            <div class="col-4 d-flex flex-column">
              <div class="chord-list mine" @dragover.prevent @drop="drop">
                <h5>My Chords</h5>
                <ul>
                  <li v-for="chord in myChords" draggable="true" @dragstart="dragStart">
                    <fret-board boardSize="tiny" :chord="chord"></fret-board>
                  </li>
                </ul>
              </div>
            </div>
            <div class="col-4 d-flex flex-column">
              Other stuff here ...
            </div>
          </div>
        </div>
      </div>
      <div class="footer text-center p-3 mt-auto">Footer</div>
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
