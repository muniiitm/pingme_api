class App < Sinatra::Base
  
  # To add the latitude and longitude values
  get '/update_latlong'do
    locations = Location.all
    locations.each do |location|
      response = GeocoderService.address_to_latlng(location.address)
      location.update(:longitude =>	response.first.longitude,:latitude=>response.first.latitude) unless response.empty?
    end
  end

  post '/associates/location' do
    access_token = params[:access_token]
    user = params[:user]

    access_token_decode = Base64.decode64(access_token)    
    user_id, secure_key = access_token.split(" ")    

    location = Location.create(:country => user[:country], :state => user[:state], :city => user[:city])
    associate_location = AssociateLocation.create(:associate_id => user_id, :location_id => location.id, :vnet => user[:vnet], :seat_number => user[:seat_number], :start_date => user[:start_date], :end_date => user[:end_date])
    
    {:access_token => access_token, :status => "success"}.to_json
  end
  
  post '/associates' do		
    unless params[:username] == ""
      associate = Associate.new
      associate.user_id = params[:username]
      associate.save		
      '{"response":{"status": "0", "message": "Success"}}'
    else
      '{"response":{"status": "1", "message": "Failed"}}'
    end
  end
end

