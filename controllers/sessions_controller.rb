class App < Sinatra::Base

  post '/users/sign_in' do		
    value = Base64.decode64(params[:user]).split(' ') 
    # Todo Need to check LDAP Authentication
     user_id = value[0]
     password = value[1]
    @user = Associate.first(:user_id => user_id)
    unless @user
      @user = Associate.create!(user_id)
    end 
    access_token =Base64.encode64("#{@user.user_id} #{SecureRandom.hex(10)}")
    {:user=>@user.to_json,:access_token=>access_token}.to_json
  end
  
  get '/users/sign_out' do
    # delete the session and cookies    
  end
end



