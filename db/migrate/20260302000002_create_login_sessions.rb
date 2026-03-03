class CreateLoginSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :login_sessions do |t|
      t.references :player, null: false, foreign_key: true
      t.string :token, null: false
      t.string :user_agent
      t.string :ip_address
      t.timestamps
    end
    add_index :login_sessions, :token, unique: true
  end
end
