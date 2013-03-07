class AssociateLocation < ActiveRecord::Base
  belongs_to :location
  belongs_to :associate
  scope :search_associates, lambda { |name,search_key,location|
    includes(:associate,:location).
    where([search_key,"%#{name}%", "%#{location}%"])
  }

  def self.create_associate_location(associate_id, location_id, start_date, end_date, vnet, seat_number)
    associate_location = AssociateLocation.find_or_create_by_associate_id_and_start_date_and_end_date(associate_id, start_date, end_date)
    associate_location.location_id = location_id
    associate_location.vnet = vnet
    associate_location.seat_number = seat_number
    associate_location.save
    return associate_location
  end
end




