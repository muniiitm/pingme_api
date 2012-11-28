$:.unshift File.expand_path("..", File.dirname(__FILE__))


require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
require 'sinatra'
require 'rspec'
require 'rack/test'

# set test environment
Sinatra::Base.set :environment, :test
Sinatra::Base.set :run, false
Sinatra::Base.set :raise_errors, true
Sinatra::Base.set :logging, false

require File.join(File.dirname(__FILE__), '..', 'app.rb')


DataMapper.setup(:default, {:adapter => 'mysql',    :host => 'localhost',    :username => 'root',    :password => '',    :database => 'pingme_web_development'})
DataMapper.auto_upgrade!
RSpec.configure do |config|
    config.include Rack::Test::Methods
    config.before(:each) { DataMapper.auto_migrate! }
end