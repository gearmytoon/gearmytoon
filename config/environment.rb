RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')
def require_all_files_in(path)
  Dir[File.join(path, "*.rb")].each {|file| require file }
end

Rails::Initializer.run do |config|
  require_all_files_in("#{RAILS_ROOT}/lib/extensions")

  if RAILS_ENV == "development"
    require 'rack/cache'
    config.middleware.use(Rack::Cache, :verbose => true, :metastore   => "file:#{RAILS_ROOT}/cache/rack/meta", :entitystore => "file:#{RAILS_ROOT}/cache/rack/body")
  end
  config.middleware.use 'ResqueWeb'

  config.time_zone = 'UTC'
  config.after_initialize do
    RPXNow.api_key = '65d9b768ba9f8c96a1d93691c53df7e59c738599'
  end
end
