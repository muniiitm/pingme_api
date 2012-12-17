class AssociateLocation < ActiveRecord::Base 
 belongs_to :location
 belongs_to :associate
scope :search_associates, lambda { |name,location|
  includes(:associate,:location).
  where(["associates.first_name LIKE ? and locations.city LIKE ?","%#{name}%", "%#{location}%"])
}
end




