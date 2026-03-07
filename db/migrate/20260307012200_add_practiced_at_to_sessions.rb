class AddPracticedAtToSessions < ActiveRecord::Migration[8.1]
  def change
    add_column :sessions, :practiced_at, :datetime
    Session.where(complete: true).update_all("practiced_at = updated_at")
  end
end
