<template>
  <div class="fretboard" :data-name="chord.name">
    <header :class="boardSize" v-if="chord">
      <span class="name">{{chord.name}}</span>&nbsp;&nbsp;<span class="bases">{{basesDisplay}}</span>
    </header>
    <div class="image"/>
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
    updated () {
      this.draw(this.$el, Object.assign({}, this.config, {chord: this.chord}, { fretGap: this.fretGap, stringGap: this.stringGap }));
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
        let canvas = el.querySelector(".image")
        canvas.innerHTML = "";
        let drawing = SVG(canvas).size(fretBoard.width + fretBoard.left + 4, fretBoard.height + fretBoard.top + 4);
        let board = drawing.rect(fretBoard.width, fretBoard.height).x(fretBoard.left).y(fretBoard.top).
          fill('white').stroke({width: 2});
        let stringPos = fretBoard.stringGap;
        let fretPos = fretBoard.fretGap;
        for (let i = 1; i < (fretBoard.numStrings - 1); ++i) {
          drawing.line(stringPos + fretBoard.left, 0 + fretBoard.top, stringPos + fretBoard.left, fretBoard.height + fretBoard.top).stroke({width: 1});
          drawing.line(0 + fretBoard.left, fretPos + fretBoard.top, fretBoard.width + fretBoard.left, fretPos + fretBoard.top).stroke({width: 1});
          stringPos += fretBoard.stringGap;
          fretPos += fretBoard.fretGap;
        }
        if (fretBoard.chord) {
          let string = 6;
          let bar = null;
          if (fretBoard.chord.notes.length > 6) {
            bar = fretBoard.chord.notes[6];
          }
          for (let string = 6; string > 0; --string) {
            let stringIdx = fretBoard.numStrings - string;
            let fret = fretBoard.chord.notes[stringIdx];
            stringPos = fretBoard.stringGap * stringIdx;
            fretPos = fretBoard.fretGap * fret;
            if (fret >= 0) {
              let fill = fret == 0 ? "white" : "black";
              let circle = drawing.circle(fretBoard.noteRadius*2).x(fretBoard.left + fretBoard.stringGap * stringIdx - fretBoard.noteRadius).
                y(fretBoard.top - fretBoard.noteRadius * 3 + fretBoard.fretGap * fret).
                stroke({width: 1}).fill(fill);
            } else {
              drawing.text("x").x(fretBoard.left + fretBoard.stringGap * stringIdx - fretBoard.noteRadius).
                y(fretBoard.top + 2 + fretBoard.fretGap * fret).font({size: fretBoard.noteRadius * 4});
            }
          }
        }
      }
    }
  }
</script>
