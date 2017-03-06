class ChordsController < ApplicationController
  def show
    @chords = Chord.all
    @player = current_player
  end

  def update
    logger.debug("Updating chords or player: #{params.inspect}")
    current_player.update(chords: params[:chords])
  end
end
