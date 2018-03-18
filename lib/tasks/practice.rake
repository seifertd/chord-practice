require 'date'

namespace :practice do
  desc "Create random practice sessions"
  task :random, [:player_id, :pairs, :starting_at, :sessions, :chords] => [:environment] do |t, args|
    starting_at = DateTime.parse(args[:starting_at])
    ending_at = DateTime.now
    sessions = args[:sessions].to_i
    chords = Chord.all.sample(args[:chords].to_i)
    days_between = (ending_at - starting_at).to_i / sessions
    p = Player.find(args[:player_id])
    puts "Creating #{sessions} random sessions of #{args[:pairs]} chord pairs from #{chords.size} chords for player #{args[:player_id]} with uuid: #{p.uuid}"
    1.upto(sessions) do
      p.random_session(number_of_pairs: args[:pairs].to_i, created_at: starting_at, chords: chords)
      starting_at = starting_at + days_between.days
      p.save!
    end
  end
end
