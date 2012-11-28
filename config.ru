require "rubygems"
require "bundler/setup"
require "sinatra"
require "sinatra/json"
require "haml"
require 'data_mapper'
require 'json'
require "sinatra/json"
require "./app"


set :run, false
set :raise_errors, true
 
run Sinatra::Application

map "/" do
  run App
end

