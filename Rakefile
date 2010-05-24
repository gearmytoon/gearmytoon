# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'
require 'resque/tasks'

task "resque:setup" => :environment

if RAILS_ENV == "deploy"
  begin
    require 'vlad'
    Vlad.load :scm => :git
  rescue LoadError
    STDERR.puts "You need to install the vlad gem. 'gem install vlad vlad-git'"
  end
end
