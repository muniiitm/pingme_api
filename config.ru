require "rubygems"
require "bundler/setup"
require "sinatra"
require "sinatra/json"
require 'sinatra/activerecord'
require 'yaml'
require "haml"
require 'json'
require "sinatra/json"
require "./app"

set :run, false
set :raise_errors, true
 
run Sinatra::Application

map "/" do
  run App
end

