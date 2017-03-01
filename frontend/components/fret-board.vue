<template>
  <div>
    <div class="fretboard">
    </div>
  </div>
</template>
<script>
  export default {
    name: 'fret-board',
    data() {
      return {
        width: 150,
        height: 210,
        top: 30,
        left: 0,
        numStrings: 6,
        noteRadius: 5,
        noteNameSize: 30,
        baseSize: 15,
        chord: {
          name: "E",
          notes: [[5,2], [4,2], [3,1]],
          bases: ["6", "4/5"]
        }
      };
    },
    mounted () {
      this.draw(this.$el, {
        width: this.width,
        height: this.height,
        top: this.top,
        left: this.left,
        numStrings: this.numStrings,
        noteRadius: this.noteRadius,
        noteNameSize: this.noteNameSize,
        baseSize: this.baseSize,
        chord: {
          name: this.chord.name,
          notes: this.chord.notes,
          bases: this.chord.bases
        },
        fretGap: this.fretGap,
        stringGap: this.stringGap
      });
    },
    computed: {
      stringGap() {
        return this.width / ( this.numStrings - 1 );
      },
      fretGap() {
        return this.height / ( this.numStrings - 1);
      }
    },
    methods: {
      draw: (el, fretBoard) => {
        bonsai.run(el.querySelector(".fretboard"), {
          code: () => {
            let fretBoardOptions = stage.options.fretBoard;
            let fretBoard = new Rect(fretBoardOptions.left, fretBoardOptions.top,
                fretBoardOptions.width, fretBoardOptions.height).stroke('#000', 3).addTo(stage);
            let stringPos = fretBoardOptions.stringGap;
            let fretPos = fretBoardOptions.fretGap;
            for (let i = 1; i < (fretBoardOptions.numStrings - 1); ++i ) {
              fretBoard.moveTo(stringPos,0).lineTo(stringPos, fretBoardOptions.height);
              fretBoard.moveTo(0, fretPos).lineTo(fretBoardOptions.width, fretPos);
              stringPos += fretBoardOptions.stringGap;
              fretPos += fretBoardOptions.fretGap;
            }

            for (let noteIdx in fretBoardOptions.chord.notes) {
              let note = fretBoardOptions.chord.notes[noteIdx];
              let string = note[0];
              let fret = note[1];
        
              stringPos = fretBoardOptions.stringGap * (fretBoardOptions.numStrings - string);
              fretPos = fretBoardOptions.fretGap * fret;
    
              new Circle(fretBoardOptions.left + fretBoardOptions.stringGap * (fretBoardOptions.numStrings - string),
                (fretBoardOptions.top - fretBoardOptions.noteRadius*2) + fretBoardOptions.fretGap * fret, fretBoardOptions.noteRadius).fill('black').addTo(stage);
            }

            new Text(fretBoardOptions.chord.name).attr({fontSize: fretBoardOptions.noteNameSize, x: fretBoardOptions.left, y: (fretBoardOptions.top - fretBoardOptions.noteNameSize)}).addTo(stage);
            new Text(fretBoardOptions.chord.bases.join(",")).attr({fontSize: fretBoardOptions.baseSize, x: fretBoardOptions.left + fretBoardOptions.noteNameSize, y: (fretBoardOptions.top - fretBoardOptions.baseSize*1.3)}).addTo(stage);
          },
          fretBoard: fretBoard,
          height: fretBoard.height + fretBoard.top + 10,
          width: fretBoard.width + fretBoard.left + 10
        });
      }
    }
  }
</script>
