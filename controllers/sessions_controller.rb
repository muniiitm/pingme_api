class App < Sinatra::Base    

  post '/users/sign_in' do		
    user_id, password = Base64.decode64(params[:user]).split(' ')

    if user_id.to_i == 0 # should be a number
    	{:status => "associate_id_failed"}.to_json
    else
	    # Todo Need to check LDAP Authentication 	   		    
	    associate = Associate.where("user_id = #{user_id}").first	  	
	    associate = Associate.create(:user_id => user_id) unless associate
	    access_token =Base64.encode64("#{associate.user_id} #{SecureRandom.hex(10)}")	    
	    {:user=>associate,:access_token=>access_token, :status => "success"}.to_json  
	  end
  end
  
end



