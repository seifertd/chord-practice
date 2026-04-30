class Player < ApplicationRecord
  has_secure_password
  has_many :login_sessions, dependent: :destroy
  serialize :chords, coder: YAML, type: Array
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def start_practice_session(options)
    self.sessions.create(options)
  end

  def chord_pair_data
    self.sessions.includes(:pairs).order(:created_at).inject(Hash.new { |h, k| h[k] = [] }) do |pairs, session|
      next pairs unless session.complete
      session.pairs.inject(pairs) do |pairs, pair|
        pairs["#{pair.first}-#{pair.second}"] << { x: session.practiced_at.iso8601, y: (pair.switches.to_f / session.duration).round(1) }
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
      s.complete = true
    end
  end
end
