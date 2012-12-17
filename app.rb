require File.join(File.dirname(__FILE__), 'environment')

class App < Sinatra::Base
	before do
		@flag = false		
		unless params[:access_token].nil?
		 	@access_token = params[:access_token]		 			 	
	    access_token_decode = Base64.decode64(@access_token)	    
	    @user_id, secure_key = access_token_decode.split(" ")	    
	    associate = Associate.where("user_id = #{@user_id}").first
	    @flag = (associate.nil?) ? false : true	    
	  end	  
	end

  get "/" do
    x = Associate.where("user_id = 1")
    x.inspect
  end
end
