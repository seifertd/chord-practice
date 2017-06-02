class Player < ApplicationRecord
  serialize :chords, Array
  has_many :sessions, dependent: :destroy

  def start_practice_session(options)
    self.sessions.create(options)
  end

  def random_session(number_of_pairs = 10)
    self.sessions.create do |s|
      s.generate_random_pairs(number_of_pairs)
    end
  end
end
