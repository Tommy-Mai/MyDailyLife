# config valid for current version and patch releases of Capistrano
lock "~> 3.15.0"

set :application, "MyDailyLife"
set :repo_url, "git@github.com:Tommy-Mai/MyDailyLife.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'main'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/rails/MyDailyLife"
set :puma_conf, "/var/www/rails/MyDailyLife/config/puma.rb"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/master.key"
append :linked_files, "config/storage.yml"
append :linked_files, "config/database.yml"
# set :linked_files, fetch(:linked_files, []).push('config/settings.yml')
# set :linked_files, fetch(:linked_files, []).push('config/credentials.yml.enc')

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :rbenv_type, :system
set :rbenv_ruby, '2.5.8'
set :rbenv_path, '/home/AWSmydailylife/.rbenv'

set :log_level, :debug

append :linked_dirs, '.bundle'
set :bundle_jobs, 2


namespace :deploy do
  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end