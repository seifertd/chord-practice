class CreatePairs < ActiveRecord::Migration[5.0]
  def change
    create_table :pairs do |t|
      t.string :first
      t.string :second
      t.references :session, foreign_key: true
      t.timestamps
    end
    add_index :pairs, [:session_id, :first, :second], unique: true
  end
end
