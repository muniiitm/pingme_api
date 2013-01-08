class App < Sinatra::Base    

  post '/users/sign_in' do		

    user_id, password = Base64.decode64(params[:user]).split(' ')

    ldap_auth = CTS::Ldap.new(user_id, password)	 	
	  ldap_response = ldap_auth.verify_ldap_authentication()	  

	  if ldap_response.success == true 	  	
	  	associate = Associate.where("user_id = #{user_id}").first	  	
	    associate = Associate.create(:user_id => user_id, :email => ldap_response.user[:mail], :first_name => ldap_response.user[:givenname], :last_name => ldap_response.user[:sn]) unless associate
	    access_token =Base64.encode64("#{user_id} #{SecureRandom.hex(10)}")	    
	    {:user=>associate,:access_token=>access_token, :status => "success"}.to_json  
	  else
	  	{:status => "associate_id_failed"}.to_json
	  end

  end
  
end



