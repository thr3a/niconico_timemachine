# config valid only for current version of Capistrano
lock '3.5.0'

# set :application, 'my_app_name'
# set :repo_url, 'git@example.com:me/my_repo.git'
set :application, 'niconico_timemachine'
set :repo_url, ->{ "file://" + Dir::pwd + "/.git" }
set :scm, :gitcopy
set :user, "thr3a"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'
set :deploy_to, "/var/www/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :puma_threads,    [2, 2]
set :puma_workers,    0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{shared_path}/log/puma.error.log"
set :puma_error_log,  "#{shared_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

namespace :deploy do
  task :mkdir do
    on roles(:app) do
      execute :sudo, :mkdir, '-p', "#{fetch(:deploy_to)}"
      execute :sudo, :chown, "#{fetch(:user)}:#{fetch(:user)}", "#{fetch(:deploy_to)}"
    end
  end

  task :upload do
    on roles(:app) do
      fetch(:linked_files).each do |filename|
        execute :mkdir, '-p', "#{shared_path}/#{File.dirname(filename)}"
        upload!(filename, "#{shared_path}/#{filename}")
      end
    end
  end

end
