# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

begin
  require 'vlad'
  Vlad.load :scm => :git
rescue LoadError
  STDERR.puts "You need to install the vlad gem. 'gem install vlad vlad-git'"
end

begin
  require 'delayed/tasks'
rescue LoadError
  STDERR.puts "Run `rake gems:install` to install delayed_job"
end

namespace :jobs do
  task :ensure_tmp_pids do
    `mkdir tmp/pids`
  end

  desc "Start the delayed_job worker in the background."
  task :start => :ensure_tmp_pids do
    `script/delayed_job start`
  end

  desc "Restart the delayed_job worker."
  task :restart => :ensure_tmp_pids do
    `script/delayed_job restart`
  end

  desc "Stop the delayed_job worker."
  task :stop => :ensure_tmp_pids do
    `script/delayed_job stop`
  end
end
