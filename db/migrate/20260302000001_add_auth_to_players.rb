class AddAuthToPlayers < ActiveRecord::Migration[7.2]
  def change
    add_column :players, :email_address, :string
    add_column :players, :password_digest, :string
    add_index :players, :email_address, unique: true
  end
end
