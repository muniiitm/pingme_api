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