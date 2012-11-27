class Location
  include DataMapper::Resource
  
  property :id, Serial
  property :address, Text
  property :city, String 
  property :state, String 
  property :country, String 
  property :pincode, String
  property :latitude, Float
  property :longitude, Float
  property :geocoder_service, String
  property :user_defined, Boolean
  property :created_at, DateTime
  property :updated_at, DateTime

end
