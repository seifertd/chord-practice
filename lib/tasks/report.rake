namespace :report do
  desc "Summary of new signups and logins (default: last 7 days)"
  task :summary, [ :days ] => [ :environment ] do |t, args|
    days = (args[:days] || 7).to_i
    since = days.days.ago

    puts "=" * 50
    puts "Report: last #{days} days (since #{since.strftime("%Y-%m-%d")})"
    puts "=" * 50

    Rake::Task["report:signups"].invoke(days)
    puts
    Rake::Task["report:logins"].invoke(days)
  end

  desc "New registered players (default: last 7 days)"
  task :signups, [ :days ] => [ :environment ] do |t, args|
    days = (args[:days] || 7).to_i
    since = days.days.ago

    players = Player.where.not(email_address: nil)
                    .where(created_at: since..)
                    .order(created_at: :desc)

    puts "New signups (#{players.count}):"
    if players.any?
      players.each do |p|
        puts "  #{p.created_at.strftime("%Y-%m-%d %H:%M")}  #{p.name || "(no name)"}  <#{p.email_address}>"
      end
    else
      puts "  (none)"
    end
  end

  desc "Recent logins (default: last 7 days)"
  task :logins, [ :days ] => [ :environment ] do |t, args|
    days = (args[:days] || 7).to_i
    since = days.days.ago

    sessions = LoginSession.includes(:player)
                           .where(created_at: since..)
                           .order(created_at: :desc)

    puts "Logins (#{sessions.count}):"
    if sessions.any?
      sessions.each do |s|
        name = s.player.email_address || s.player.uuid
        puts "  #{s.created_at.strftime("%Y-%m-%d %H:%M")}  #{name}  #{s.ip_address}"
      end
    else
      puts "  (none)"
    end
  end
end
