class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.integer :duration
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
