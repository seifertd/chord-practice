class ChordsController < ApplicationController
  before_action :load_user_data

  def show
  end

  def update
    @player.update(chords: params[:chords])
    respond_to do |format|
      format.json { head :ok }
      format.html { render :show }
    end
  end

  private

  def load_user_data
    @player = current_player
    player_chord_names = (@player.chords || []).to_set
    @my_chords      = Chord.all.select { |c| player_chord_names.include?(c.name) }
    @library_chords = Chord.all.reject { |c| player_chord_names.include?(c.name) }
  end
end
