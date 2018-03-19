class Player < ApplicationRecord
  serialize :chords, Array
  has_many :sessions, dependent: :destroy

  def start_practice_session(options)
    self.sessions.create(options)
  end

  def chord_pair_data
    self.sessions.inject(Hash.new{|h,k| h[k] = []}) do |pairs, session|
      if !session.complete
        return pairs
      end
      session.pairs.inject(pairs) do |pairs, pair|
        pairs["#{pair.first}-#{pair.second}"] << {t: session.created_at.iso8601, y: pair.switches}
        pairs
      end
    end
  end

  def chord_pairs
    self.sessions.inject(Hash.new(0)) do |pairs, session|
      session.pairs.inject(pairs) do |pairs, pair|
        pairs["#{pair.first}-#{pair.second}"] += 1
        pairs
      end
      pairs
    end
  end

  def random_session(options)
    number_of_pairs, created_at, chords = options.values_at(:number_of_pairs, :created_at, :chords)
    session = self.sessions.create do |s|
      s.created_at = created_at
      s.generate_random_pairs(number_of_pairs, chords: chords, switches: :random)
    end
  end
end
