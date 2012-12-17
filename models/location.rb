class Location < ActiveRecord::Base  
  has_many :associates,:through => :associate_location
end