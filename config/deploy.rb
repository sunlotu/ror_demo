# Capistrano的staging环境下部署Rails的production环境
# +lock+ config valid only for current version of Capistrano
# +SCM+ source control management
# +linked_files+ 将shared中的文件链接到项目中，文件要首先存在于shared目录中，不然deploy时会报错
# +linked_dirs+ 将项目的指定目录链接到shared目录中

# append :linked_files, "config/database.yml", "config/secrets.yml"
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

## Defaults:
# set :scm,           :git
# set :pty,           :false
# set :branch,        :master
# set :format,        :airbrussh
# set :log_level,     :debug
# set :keep_releases, 5
# set :linked_files,  []
# set :linked_dirs,   []
# set :default_env,   {}
# set :local_user,    ENV['USER']
# set :deploy_to,     /var/www/my_app_name

lock "3.9.0"

set :application, "ror_demo"
set :repo_url, "git@two.github.com:sunlotu/ror_demo.git"

set :pty,             true
set :use_sudo,        false
set :format,          :pretty
set :log_level,       :info
set :user,            'lian'

set :rails_env,       :production

set :deploy_to,       "/home/lian/deploy/ror_demo"

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# set :ssh_options, {forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub)}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :local_user, -> { `git config user.name`.chomp }

set :linked_files, %w(config/database.yml config/secrets.yml)
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

SSHKit.config.command_map[:rake]  = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.4.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# PUMA
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,   "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix:///#{shared_path}/tmp/sockets/puma.sock"      #根据nginx配置链接的sock进行设置，需要唯一
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 16]
set :puma_workers, 0
set :puma_init_active_record, false
set :puma_preload_app, true

# namespace :puma do
#   desc 'Create Directories for Puma Pids and Socket'
#   task :make_dirs do
#     on roles(:app) do
#       execute "mkdir #{shared_path}/tmp/sockets -p"
#       execute "mkdir #{shared_path}/tmp/pids -p"
#     end
#   end
#
#   before :start, :make_dirs
# end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
