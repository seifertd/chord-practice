<template>
  <div class="fretboard">
    <header :class="boardSize" v-if="chord">
      <span class="name">{{chord.name}}</span>&nbsp;&nbsp;<span class="bases">{{basesDisplay}}</span>
    </header>
    <div class="image">
    </div>
  </div>
</template>
<script>
  const configs = {
    default: {
      width: 150,
      height: 210,
      top: 30,
      left: 5,
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
      left: 5,
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
      left: 5,
      stroke: 1,
      numStrings: 6,
      noteRadius: 3,
      noteNameSize: 12,
      baseSize: 7
    }
  };
  export default {
    name: 'fret-board',
    props: {
      boardSize: {
        type: String,
        default: 'default'
      },
      chord: Object
    },
    mounted () {
      this.draw(this.$el, Object.assign({}, this.config, {chord: this.chord}, { fretGap: this.fretGap, stringGap: this.stringGap }));
    },
    computed: {
      config() {
        return configs[this.boardSize];
      },
      basesDisplay() {
        return this.chord && this.chord.bases.join(",");
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
        bonsai.run(el.querySelector(".image"), {
          code: () => {
            let fretBoardOptions = stage.options.fretBoard;
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
            fretBoard.addTo(stage);

            if (fretBoardOptions.chord) {
              let string = 6;
              for (let string = 6; string > 0; --string) {
                let fret = fretBoardOptions.chord.notes[fretBoardOptions.numStrings - string];
                stringPos = fretBoardOptions.stringGap * (fretBoardOptions.numStrings - string);
                fretPos = fretBoardOptions.fretGap * fret;
     
                if (fret >= 0) {
                  let circle = new Circle(fretBoardOptions.left + fretBoardOptions.stringGap * (fretBoardOptions.numStrings - string),
                    (fretBoardOptions.top - fretBoardOptions.noteRadius*2) + fretBoardOptions.fretGap * fret, fretBoardOptions.noteRadius).stroke('#000', 1)
                  if (fret > 0) {
                    circle.fill('black');
                  }
                  circle.addTo(stage);
                } else {
                  new Text('x').attr({fontSize: fretBoardOptions.noteRadius * 4, x: fretBoardOptions.left - fretBoardOptions.noteRadius + fretBoardOptions.stringGap * (fretBoardOptions.numStrings - string), y: (fretBoardOptions.top - fretBoardOptions.noteRadius*3.8)}).addTo(stage);
                }
              }
            }
          },
          fretBoard: fretBoard,
          height: fretBoard.height + fretBoard.top + 10,
          width: fretBoard.width + fretBoard.left + 10
        });
      }
    }
  }
</script>
