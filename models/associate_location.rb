class AssociateLocation
  include DataMapper::Resource
  
  property :id, Serial
  property :associate_id, Integer
  property :location_id, String 
  property :vnet, Integer
  property :seat_number, String
  property :start_date, DateTime
  property :end_date, DateTime
  property :created_at, DateTime  
  property :updated_at, DateTime

  belongs_to :associate
  belongs_to :location

end
