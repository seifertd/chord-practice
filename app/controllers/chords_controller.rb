class ChordsController < ApplicationController
  before_action :load_user_data

  def show
  end

  def update
    logger.debug("Updating chords or player: #{params.inspect}")
    @player.update(chords: params[:chords])
    render :show
  end

  private

  def load_user_data
    @chords = Chord.all
    @player = current_player
  end
end
