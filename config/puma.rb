threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

port ENV.fetch("PORT", 3000)

if ENV["RAILS_ENV"] == "production"
  workers ENV.fetch("WEB_CONCURRENCY", 2)
  preload_app!
end

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Specify the PID file. Defaults to tmp/pids/server.pid in development.
# In other environments, only set the PID file if requested.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
