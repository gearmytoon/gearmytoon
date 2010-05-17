set :application, "project"
set :domain, "deploy@gearmytoon.com"
set :deploy_to, "/var/public_html/gearmytoon.com/"
set :repository, 'git@github.com:nolman/wowcoach.git'
set :ssh_flags, ['-p 60322']
set :revision, 'master' # git branch to deploy
set :web_command, 'sudo apache2ctl' # command to start/stop apache

namespace :vlad do
  desc "deploy the app"
  task :deploy => %w[
    vlad:update
    vlad:bundle:install
    vlad:migrate
    vlad:start
  ]

  desc "import a text file via wow armory on production"
  remote_task :import_a_items_text_file do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} rake import_a_items_text_file NAME=#{ENV['NAME']}"
  end

  desc "import all text files via wow armory on production"
  remote_task :import_all_items_from_text_files do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} rake import_all_item_text_files"
  end

  desc "import all items that match a term from wow armory on production"
  remote_task :import_pvp_gear do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} rake import_by_wow_armory_search TERM=\"Relentless Gladiator's\""
    run "cd #{current_path} && RAILS_ENV=#{rails_env} rake import_by_wow_armory_search TERM=\"furious Gladiator's\""
    run "cd #{current_path} && RAILS_ENV=#{rails_env} rake import_by_wow_armory_search TERM=\"wrathful Gladiator's\""
  end

  namespace :bundle do
    desc "install gems"
    remote_task :install do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle install"
    end
  end
end
