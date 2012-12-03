class App < Sinatra::Base  

  get '/test'do    
   "welocme"   
  end

  post '/associates/location' do
    access_token = params[:access_token]
    user = params[:user]

    access_token_decode = Base64.decode64(access_token)        
    user_id, secure_key = access_token_decode.split(" ")   
    associate = Associate.first(:user_id => "#{user_id}")

    if associate      
      location = Location.first(:country => user[:country], :state => user[:state], :city => user[:city])      
      location = Location.create(:country => user[:country], :state => user[:state], :city => user[:city]) unless location
      associate_location = AssociateLocation.create(:associate_id => user_id, :location_id => location.id, :vnet => user[:vnet], :seat_number => user[:seat_number], :start_date => user[:start_date], :end_date => user[:end_date])
      
      {:access_token => access_token, :status => "success"}.to_json
    else      
      {:access_token => access_token, :status => "failed"}.to_json
    end
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