set :application, "project"
set :domain, "deploy@wow.telcobox.net"
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

  desc "import a text file via wow armory on production"
  remote_task :import_a_items_text_file do
    run "cd #{current_path} && RAILS_ENV=production rake import_a_items_text_file NAME=#{ENV['NAME']}"
  end

  desc "import all text files via wow armory on production"
  remote_task :import_all_items_from_text_files do
    run "cd #{current_path} && RAILS_ENV=production rake import_all_item_text_files"
  end

end
