set :application, "project"
set :domain, "deploy@gearmytoon.com"
set :deploy_to, "/var/www/gearmytoon.com/"
set :repository, 'git@github.com:nolman/gearmytoon.git'
set :revision, 'master' # git branch to deploy
set :web_command, 'sudo service nginx' # command to start/stop nginx

namespace :vlad do
  desc "bootstrap app"
  task :bootstrap => %w[
    vlad:update
    vlad:bundle:install
    vlad:setup_db
    vlad:start
  ]

  desc "deploy the app"
  task :deploy => %w[
    vlad:update
    vlad:bundle:install
    vlad:migrate
    vlad:start
    vlad:resque:restart
    vlad:notify_hoptoad
  ]

  desc "setup database"
  task :setup_db => %w[
    vlad:db:create
    vlad:migrate
    vlad:db:seed
    vlad:db:import_all_items_from_text_files
  ]

  namespace :db do
    desc "seed database with necessary infoz"
    remote_task :seed do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} rake db:seed"
    end

    desc "create database"
    remote_task :create do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} rake db:create"
    end

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

    desc "kill all production workers"
    remote_task :kill_workers do
      run "cd #{current_path} && rake kill_workers"
    end
  end

  namespace :resque do
    desc "restart resque worker"
    remote_task :restart do
      run "sudo monit restart resque_worker_QUEUE"
    end
  end

  namespace :bundle do
    desc "install gems"
    remote_task :install do
      run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle install --without test"
    end
  end

  # hoptoad
  task :notify_hoptoad => [:git_user, :git_revision] do
    notify_command = "rake hoptoad:deploy TO=#{rails_env} REVISION=#{current_sha} REPO=#{repository} USER='#{current_user}'"
    puts "Notifying Hoptoad of Deploy (#{notify_command})"
    `#{notify_command}`
    puts "Hoptoad Notification Complete."
  end
end

remote_task :git_revision do
  set :current_sha, run("cd #{File.join(scm_path, 'repo')}; git rev-parse origin/master").strip
end

task :git_user do
  set :current_user, `git config --get user.name`.strip
end
