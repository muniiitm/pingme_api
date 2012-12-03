class AssociateLogin
	include DataMapper::Resource
  
  property :id, Serial
  property :associate_id, Integer
  property :location_id, String   
  property :login_ip, String 
  property :login_latitude, Float
  property :login_longitude, Float
  property :created_at, DateTime 
  property :updated_at, DateTime 

  belongs_to :associate
  belongs_to :location

end