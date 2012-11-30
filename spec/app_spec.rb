require "spec_helper.rb"

describe App do

def app
  @app ||= App
end

	describe 'get /' do
		it 'should say hello' do
			get "/"
			last_response.should be_ok
		end
	end
  
  describe 'signin' do
    it 'should login' do
      post '/users/sign_in',{:user=>"MzQxMjY5IHNhcmFueWEx\n"}
      last_response.should be_ok
    end
  end
  
  describe 'Associate can update the location' do
    it 'Create the location' do
      params = {:user=>{:country=>"india",:state=>"tamilnadu",:city=>"chennai",:associate_id=>"341269",:vnet=>"451234",:seat_number=>"PKN7A053",:state_date=>Time.now,:end_date=>"Time.now"},:access_token=>"MzQxMjY5IHNhcmFueWEx\n"}
      post '/associates/location', params
      last_response.should be_ok
    end
  end  
end

