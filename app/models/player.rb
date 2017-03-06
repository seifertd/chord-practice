class Player < ApplicationRecord
  serialize :chords, Array
  has_many :sessions, dependent: :destroy
end
