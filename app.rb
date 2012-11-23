require './models/associate'

configure :development do
  require './db/database'
end

set :json_encoder, :to_json

get '/' do
  @associate = Associate.all 
  @associate.to_yaml
end
