require "spec_helper"

describe 'associate' do
  before(:each) do
    @associate = Associate.new(:first_name => 'rajalakshmi')
  end

  specify 'should be valid' do
    @associate.should be_valid
  end

  specify ' update the user details' do
    associate =  FactoryGirl.create(:associate1)
    associate.last_name = "velu"
    associate.save
    associate.should be_valid
  end
end




