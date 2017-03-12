class Player < ApplicationRecord
  serialize :chords, Array
  has_many :sessions, dependent: :destroy

  def start_practice_session(options)
    self.sessions.create(options)
  end
end
