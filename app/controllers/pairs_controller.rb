class PairsController < ApplicationController
  # DELETE /pairs/:id
  # Removes a pair from its session (used to skip a pair mid-practice).
  # Pass block=true to also add the pair to the player's blocklist so it is
  # excluded from future sessions.
  def destroy
    pair = Pair.find(params[:id])
    return head :forbidden unless pair.session.player_id == current_player.id

    if ActiveModel::Type::Boolean.new.cast(params[:block])
      current_player.block_pair(pair.first, pair.second)
    end
    pair.destroy
    head :ok
  end
end
