class AddBlockedPairsToPlayers < ActiveRecord::Migration[8.1]
  def change
    add_column :players, :blocked_pairs, :text, default: "--- []\n"
  end
end
