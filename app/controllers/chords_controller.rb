class ChordsController < ApplicationController
  def index
    @chords = Chord.all
  end
end
