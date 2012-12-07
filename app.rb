require File.join(File.dirname(__FILE__), 'environment')

class App < Sinatra::Base
  get "/" do
    x = Associate.where("user_id = 1")
    x.inspect
  end
end
