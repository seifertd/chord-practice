class Session < ApplicationRecord
  belongs_to :player
  has_many :pairs, dependent: :destroy

  def started
    pairs.any?(&:complete)
  end

  def done
    pairs.all?(&:complete)
  end

  def generate_random_pairs(number_of_pairs, options = {})
    chords = options[:chords] || Chord.all
    switches = options[:switches]
    chord_combos = chords.sort_by(&:name).combination(2).to_a
    chord_combos.sample(number_of_pairs).each do |chord|
      num_switches = if switches == :random
        5 + Random.rand(100)
      end
      self.pairs.build(first: chord[0].name, second: chord[1].name, switches: num_switches)
    end
    self.pairs
  end

end
