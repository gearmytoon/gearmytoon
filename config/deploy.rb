set :application, "project"
set :domain, "wow.telcobox.net"
set :deploy_to, "/var/public_html/wow.telcobox.net/"
set :repository, 'git@github.com:nolman/wowcoach.git'
set :ssh_flags, ['-p 60322']
set :revision, 'master' # git branch to deploy
set :web_command, 'touch /var/public_html/wow.telcobox.net/current/tmp/restart.txt' # command to start/stop apache

namespace :vlad do
  desc "deploy the app"
  task :deploy => %w[
    vlad:update
    vlad:migrate
    vlad:start
  ]
end
