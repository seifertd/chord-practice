class Session < ApplicationRecord
  belongs_to :player
  has_many :pairs, dependent: :destroy

  def generate_random_pairs(number_of_pairs, chords = Chord.all)
    pairs = Set.new
    chord_combos = chords.sort_by(&:name).combination(2).to_a
    chord_combos.sample(number_of_pairs).each do |chord|
      self.pairs.build(first: chord[0].name, second: chord[1].name)
    end
  end
end
