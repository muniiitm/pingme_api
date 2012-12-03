require "spec_helper"
describe 'associate location' do
  before(:each) do
     associate =  FactoryGirl.create(:associate1)
     location =  FactoryGirl.create(:location_valid)
    @associate_location = AssociateLocation.new(:associate_id => associate.id,:end_date=>Time.now,:start_date=>Time.now,:location_id=>location.id,:seat_number=>'PKN7A053',:vnet=>'45')
  end

  specify 'should be valid' do
    @associate_location.should be_valid
  end

  specify 'Update the associate location details' do
    @associate_location.vnet = '451743'
    @associate_location.save
    @associate_location.should be_valid
  end
end


