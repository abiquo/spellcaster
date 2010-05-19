require File.join(File.dirname(__FILE__), 'vendor/gems/environment')
require 'sinatra'
require 'haml'
require 'json'
require 'time'
require 'logger'
require 'singleton'
require 'pp'
require 'erb'
require 'resque'
require 'pony'
require 'rack/contrib'
require File.join(Sinatra::Application.root, "lib/spellcaster.rb")
require File.join(Sinatra::Application.root, "config/settings_#{ENV['RACK_ENV']||'development'}")

enable :raise_errors
use Rack::Session::Cookie
use Rack::MailExceptions do |mail|
  mail.to(Sinatra::Application.mail_errors_to)
  mail.subject '[spellcaster][EXCEPTION] %s'
end

############# MODELS #############
Dir[File.join(File.dirname(__FILE__), 'app/models/*.rb')].each do |f|
  puts "loading #{f}"
  require f
end

############# FILTERS ############
Dir[File.join(Sinatra::Application.root, 'app/filters/*.rb')].each do |f|
  require f
end

############## ROUTES ############
Dir[File.join(Sinatra::Application.root, 'app/routes/*.rb')].each do |f|
  require f
end

############## HELPERS ############
helpers do
  Dir[File.join(Sinatra::Application.root, 'app/helpers/*.rb')].each do |f|
    require f
  end
end
