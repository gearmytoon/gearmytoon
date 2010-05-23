RAILS_GEM_VERSION = '2.3.6' unless defined? RAILS_GEM_VERSION

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
  config.after_initialize do
    RPXNow.api_key = '65d9b768ba9f8c96a1d93691c53df7e59c738599'
  end
end
