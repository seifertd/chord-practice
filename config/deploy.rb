# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "chord-practice"
set :repo_url, "git@github.com:seifertd/chord-practice.git"
set :user, "das67"
set :tmp_dir, "/home/das67/tmp"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/das67/repos/chord-practice"

set :deploy_via, :remote_cache
set :copy_exlude, [ '.git' ]
set :use_sudo, false
set :scm_verbose, true

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


# Passenger settings:
set :passenger_restart_with_touch, true

# RVM settings
set :rvm_ruby_version, 'ruby-2.4.1@chord-practice'
set :rvm_type, :local

namespace :deploy do
  namespace :assets do
    task :precompile do
      on roles(:app) do
        within "#{current_path}" do
          with rails_env: "#{fetch(:stage)}" do
            execute :rake, "assets:precompile"
          end
        end
      end
    end
  end
end
