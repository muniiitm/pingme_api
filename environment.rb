require 'rubygems'
require 'bundler/setup'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-migrations'
require 'haml'


require 'sinatra' unless defined?(Sinatra)

configure do
  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }
  Dir["./models/*.rb"].each { |model| require model }
  Dir["./controllers/*.rb"].each { |controller| require controller }


   DataMapper.setup(:default, {
    :adapter => 'mysql',
    :host => 'localhost',
    :username => 'root',
    :password => '',
    :database => 'pingme_web_development'})

  DataMapper.auto_upgrade!
end
