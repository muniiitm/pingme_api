configure do
  # load libraries 
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }

  # load models
  Dir["./models/*.rb"].each { |model| require model }

  # load controllers
  Dir["./controllers/*.rb"].each { |controller| require controller }

  # load database configuration 
  DB_CONFIG = YAML::load(File.open('config/database.yml'))

  ActiveRecord::Base.establish_connection(
    :adapter => DB_CONFIG['adapter'],
    :host =>  DB_CONFIG['host'],
    :database => DB_CONFIG['database'],
    :username => DB_CONFIG['username'],
    :password => DB_CONFIG['password']
  )
end
