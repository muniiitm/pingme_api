class App < Sinatra::Base  

  get '/update_latlong'do
    locations = Location.all
    locations.map do |location|
      if !location.address.nil?
        response = GeocoderService.address_to_latlng(location.address)         
        location.update_attributes(:longitude => response.first.longitude,:latitude=>response.first.latitude) unless response.nil?
      end      
    end        
  end

  post '/associates/location' do
    access_token = params[:access_token]
    user = params[:user]
    
    access_token_decode = Base64.decode64(access_token)        
    user_id, secure_key = access_token_decode.split(" ") 

    associate = Associate.where("user_id = #{user_id}").first

    if associate      
      location = Location.where(["country = ? and city = ? and state = ?", user["country"], user["city"], user["state"]]).first      
      location = Location.create(:country => user["country"], :state => user["state"], :city => user["city"]) unless location
      associate_location = AssociateLocation.create(:associate_id => user_id, :location_id => location.id, :vnet => user["vnet"], :seat_number => user["seat_number"], :start_date => user["start_date"], :end_date => user["end_date"])
      
      {:location => location, :access_token => access_token, :status => "success"}.to_json
    else      
      {:access_token => access_token, :status => "failed"}.to_json
    end
  end
  
  get '/locations' do
  end 
end