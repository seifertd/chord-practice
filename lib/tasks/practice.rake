namespace :practice do
  desc "Create random practice session"
  task :random, [:player_id, :pairs] => [:environment] do |t, args|
    p = Player.find(args[:player_id])
    puts "Creating random session of #{args[:pairs]} for player #{args[:player_id]} with uuid: #{p.uuid}"
    p.random_session(args[:pairs])
    p.save!
  end
end
