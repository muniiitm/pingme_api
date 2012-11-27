# to load all models
Dir["./models/*.rb"].each { |model| require model }

# Database connection 
configure :development do
  require './db/database'
end

require './controllers/associates_controller'

get '/' do
  @associate = Associate.all 
  erb :index
end
