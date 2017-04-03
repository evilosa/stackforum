# config valid only for current version of Capistrano
lock '3.8.0'

set :application, 'stackforum'
set :repo_url, 'git@github.com:mbconsalting/stackforum.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/stackforum'
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/secrets.yml', '.env', 'config/sidekiq.yml', 'config/production.sphinx.conf', 'config/thinking_sphinx.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'vendor/bundle', 'public/uploads'

# Default value for keep_releases is 5
set :keep_releases, 10

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end