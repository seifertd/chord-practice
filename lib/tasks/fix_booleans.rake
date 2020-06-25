namespace :datafix do
  desc "Reset sqlite booleans"
  task :booleans => :environment do
    Session.where("complete = 't'").update_all(complete: 1)
    Session.where("complete = 'f'").update_all(complete: 0)
  end
end
