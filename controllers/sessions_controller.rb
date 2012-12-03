class App < Sinatra::Base
  require 'geocoder_service'
  
  post '/users/sign_in' do		
    user_id, password = Base64.decode64(params[:user]).split(' ') 
    # Todo Need to check LDAP Authentication    
    associate = Associate.first(:user_id => user_id)        
    associate = Associate.create(:user_id => user_id) unless associate    
    
    access_token =Base64.encode64("#{associate.user_id} #{SecureRandom.hex(10)}")
    
    {:user=>associate,:access_token=>access_token, :status => "success"}.to_json
  end
  
end



