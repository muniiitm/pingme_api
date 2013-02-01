require File.join(File.dirname(__FILE__), 'environment')

class App < Sinatra::Base
	register Sinatra::Initializers

	before do
		@flag = false
		unless params[:access_token].nil?
		 	@access_token = params[:access_token]
	    access_token_decode = Base64.decode64(@access_token)
	    @user_id, secure_key = access_token_decode.split(" ")
	    @associate = Associate.where("user_id = #{@user_id}").first
	    @flag = (@associate.nil?) ? false : true
	  end
	end

  get "/" do
  	"Welcome To Pingme !!!"
  end

  # Update the latitude and longitude for given location object.
  # location is an object which is come from '/associates/location' action.
  def update_lat_and_lon(location)
    if !location.address.nil?
      response = GeocoderService.address_to_latlng(location.address)
      location.update_attributes(:longitude => response.first.longitude,:latitude=>response.first.latitude) unless response.nil?
    end
  end


end
