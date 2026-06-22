class Player < ApplicationRecord
  has_secure_password
  has_many :login_sessions, dependent: :destroy
  serialize :chords, coder: YAML, type: Array
  serialize :blocked_pairs, coder: YAML, type: Array
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def start_practice_session(options)
    self.sessions.create(options)
  end

  # Add a chord pair to the blocklist so it is excluded from future sessions.
  # Keys are stored as "first-second" (chords in alphabetical order, matching
  # how pairs are generated).
  def block_pair(first, second)
    update(blocked_pairs: blocked_pairs | [ "#{first}-#{second}" ])
  end

  def pair_blocked?(first, second)
    blocked_pairs.include?("#{first}-#{second}")
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

  # Most recent switch count for each chord pair, drawn from completed sessions.
  # Keyed by "first-second". Optionally excludes a session (e.g. the one in progress).
  def last_switches_by_pair(excluding_session: nil)
    scope = self.sessions.where(complete: true).includes(:pairs).order(practiced_at: :desc)
    scope = scope.where.not(id: excluding_session.id) if excluding_session&.persisted?
    scope.each_with_object({}) do |session, result|
      session.pairs.each do |pair|
        key = "#{pair.first}-#{pair.second}"
        result[key] ||= pair.switches
      end
    end
  end

  # Highest switch count ever achieved for each chord pair, from completed sessions.
  # Keyed by "first-second". Optionally excludes a session (e.g. the one in progress).
  def best_switches_by_pair(excluding_session: nil)
    scope = self.sessions.where(complete: true).includes(:pairs)
    scope = scope.where.not(id: excluding_session.id) if excluding_session&.persisted?
    scope.each_with_object({}) do |session, result|
      session.pairs.each do |pair|
        key = "#{pair.first}-#{pair.second}"
        result[key] = pair.switches if result[key].nil? || pair.switches > result[key]
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
