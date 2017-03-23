class Session < ApplicationRecord
  belongs_to :player
  has_many :pairs, dependent: :destroy

  def generate_random_pairs(number_of_pairs, chords = Chord.all)
    pairs = Set.new
    chord_combos = chords.combination(2).to_a
    chord_combos.sample(number_of_pairs).each do |chord|
      puts "CHORD1: #{chord[0].inspect}"
      puts "CHORD2: #{chord[1].inspect}"
    end
  end
end
