#~ require './lib/geocoder_service'
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require File.join(File.dirname(__FILE__), 'environment')


configure :development do
  require './db/database'
end


class App < Sinatra::Base
  get "/" do
    Associate.all
    "test"
  end
end