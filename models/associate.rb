class Associate < ActiveRecord::Base 
  has_many :locations, :through => :associate_location

end