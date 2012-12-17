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
    user = params[:user]    
    if @flag      
      location = Location.where(["country = ? and city = ? and state = ?", user["country"], user["city"], user["state"]]).first      
      location = Location.create(:country => user["country"], :state => user["state"], :city => user["city"]) unless location
      associate_location = AssociateLocation.create(:associate_id => @user_id, :location_id => location.id, :vnet => user["vnet"], :seat_number => user["seat_number"], :start_date => user["start_date"], :end_date => user["end_date"])      
      {:location => location, :access_token => @access_token, :status => "success"}.to_json
    else            
      {:status => "failed"}.to_json
    end
  end
  
  get '/locations' do
    if @flag
      locations = Location.all                    
      addresses = locations.map(&:address).uniq.reject { |a| a.nil? }    
      countries = locations.map(&:country).uniq.reject { |c| c.nil? }
      states = locations.map(&:state).uniq.reject { |s| s.nil? }
      cities = locations.map(&:city).uniq.reject { |c| c.nil? }
      {:addresses => addresses, :countries => countries, :states => states, :cities => cities, :access_token => @access_token, :status => "success"}.to_json
    else            
      {:status => "failed"}.to_json    
    end
  end 
end
