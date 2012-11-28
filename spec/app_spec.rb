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
end
