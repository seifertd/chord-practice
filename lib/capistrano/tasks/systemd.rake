namespace :deploy do
  task :restart do
    on roles(:app) do
      execute :systemctl, "--user restart chordpractice.service"
    end
  end

  after :publishing, :restart
end
