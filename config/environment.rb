RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
def require_all_files_in(path)
  Dir[File.join(path, "*.rb")].each {|file| require file }
end
Rails::Initializer.run do |config|
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir|
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end

  require_all_files_in("#{RAILS_ROOT}/lib/extensions")

  config.time_zone = 'UTC'
  config.gem "pwood-wowr", :version => "0.5.1", :lib => "wowr", :source => "http://gems.github.com"
  config.gem "json", :version => "1.2.0"
  config.gem "mechanize", :version => "0.9.3"
  config.gem 'ruby-openid', :lib => 'openid', :version => '2.1.7'
  config.gem 'authlogic', :version => '2.1.3'
  config.gem 'rpx_now', :version => '0.6.17'
  config.gem "friendly_id", :version => "~> 2.3"
  config.gem 'delayed_job', :version => '2.0.1'
  config.gem 'remit', :version => '0.0.5'
  config.gem "acts_as_state_machine", :version => "2.2.0"
  config.after_initialize do
    RPXNow.api_key = '65d9b768ba9f8c96a1d93691c53df7e59c738599'
  end
end
