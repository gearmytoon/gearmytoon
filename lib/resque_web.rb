require 'sinatra/base'

class ResqueWeb < Sinatra::Base
  require 'resque/server'
  use Rack::ShowExceptions

  AUTH_PASSWORD = 'g34r4you' || ENV['AUTH']
  if AUTH_PASSWORD
    Resque::Server.use Rack::Auth::Basic do |username, password|
      password == AUTH_PASSWORD
    end
  end

  def call(env)
    if env["PATH_INFO"] =~ /^\/resque/
      env["PATH_INFO"].sub!(/^\/resque/, '')
      env['SCRIPT_NAME'] = '/resque'
      app = Resque::Server.new
      app.call(env)
    else
      super
    end
  end
end
