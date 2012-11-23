class Associate
  include DataMapper::Resource
  
  property :id, Serial
  property :user_id, Integer
  property :first_name, String 
  property :last_name, String 
  property :email, String 
  property :created_at, DateTime 
  property :updated_at, DateTime 
end