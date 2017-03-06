class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :uuid
      t.string :name
      t.text :chords, :default => [].to_yaml
      t.timestamps
    end
    add_index :players, :uuid, unique: true
    add_index :players, :name
  end
end
