require "#{File.dirname(__FILE__)}/spec_helper"

describe 'associate' do
  before(:each) do
    @associate = Associate.new(:first_name => 'test user')
  end

  specify 'should be valid' do
    @associate.should be_valid
  end

  specify 'should require a name' do
    @associate = Associate.new
    @associate.should be_valid
  end
end


