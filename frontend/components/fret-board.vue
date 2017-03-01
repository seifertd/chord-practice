<template>
  <div>
    <div class="fretboard">
    </div>
  </div>
</template>
<script>
  const configs = {
    default: {
      width: 150,
      height: 210,
      top: 30,
      left: 0,
      stroke: 3,
      numStrings: 6,
      noteRadius: 7,
      noteNameSize: 30,
      baseSize: 15
    },
    small: {
      width: 75,
      height: 105,
      top: 15,
      left: 0,
      stroke: 1,
      numStrings: 6,
      noteRadius: 4,
      noteNameSize: 15,
      baseSize: 9
    },
    tiny: {
      width: 50,
      height: 70,
      top: 12,
      left: 0,
      stroke: 1,
      numStrings: 6,
      noteRadius: 3,
      noteNameSize: 12,
      baseSize: 7
    }
  };
  export default {
    name: 'fret-board',
    data() {
      return {
        chord: {
          name: "E",
          notes: [[5,2], [4,2], [3,1]],
          bases: ["6", "4/5"]
        },
        size: 'tiny'
      };
    },
    mounted () {
      this.draw(this.$el, Object.assign({}, this.config, {chord: this.chord}, { fretGap: this.fretGap, stringGap: this.stringGap }));
    },
    computed: {
      config() {
        return configs[this.size];
      },
      stringGap() {
        return this.config.width / ( this.config.numStrings - 1 );
      },
      fretGap() {
        return this.config.height / ( this.config.numStrings - 1);
      }
    },
    methods: {
      draw: (el, fretBoard) => {
        bonsai.run(el.querySelector(".fretboard"), {
          code: () => {
            let fretBoardOptions = stage.options.fretBoard;
            console.log("FRET BOARD OPTS: ", stage.options.fretBoard);
            let fretBoard = new Rect(fretBoardOptions.left, fretBoardOptions.top,
                fretBoardOptions.width, fretBoardOptions.height).stroke('#000', fretBoardOptions.stroke).addTo(stage);
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
