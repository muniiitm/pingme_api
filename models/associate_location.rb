class AssociateLocation < ActiveRecord::Base 
 belongs_to :location
 belongs_to :associate
scope :search_associates, lambda { |name,search_key,location|
  includes(:associate,:location).
  where([search_key,"%#{name}%", "%#{location}%"])
}
end




