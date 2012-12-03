require "spec_helper"

describe 'location' do
  before(:each) do
    @associate = Location.new(:address => '5/535 Old Mahabalipuram Road Thoraipakkam',:state=>'tamilnadu',:country=>'india',:pincode=>'600086')
  end

  specify 'should be valid' do
    @associate.should be_valid
  end

  specify 'Update the location details' do
    @associate.city = 'chennai'
    @associate.save
    @associate.should be_valid
  end
end


