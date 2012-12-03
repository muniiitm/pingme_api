
require 'rubygems'
require 'factory_girl'

FactoryGirl.define  do |f|
  factory :associate1, :class => :associate do |f|
    f.user_id 341269
    f.first_name "rajalakshmi"
    f.last_name "velu"
    f.email "rajalakshmi.velu@cognizant.com"
  end
  factory :location_valid, :class => :location do |f|
    f.address "5/535 Old Mahabalipuram Road Thoraipakkam"
    f.state 'tamilnadu'
    f.country 'india'
    f.city 'chennai'
    f.pincode '6000886'
  end
  factory :associate_location1, :class => :associate_location do |f|
    f.associate_id 1 
    f.end_date Time.now
    f.start_date Time.now
    f.location_id 1
    f.seat_number "PKN7A053"
    f.vnet "451743"
  end
 
end



