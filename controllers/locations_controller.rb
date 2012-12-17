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

#{Date.today.beginning_of_week} and DATE(end_date) = #{Date.today.end_of_week}" 
  post '/associates/location' do
    user = params[:user]
    if @flag
      date_range = user["date_range"]
      if date_range
        current_date = DateTime.now
        start_date = current_date.strftime("%Y-%m-%d")
        end_date = "#{start_date}" if date_range == "today"
        
        if date_range == 'week'
          start_date = Date.today.beginning_of_week.strftime("%Y-%m-%d")
          end_date = Date.today.end_of_week.strftime("%Y-%m-%d") 
        end
      else
        start_date = user["start_date"]
        end_date = user["end_date"]
      end
      if !start_date.blank? && !end_date.blank?
        location = Location.where(["country = ? and city = ? and state = ?", user["country"], user["city"], user["state"]]).first
        location = Location.create(:country => user["country"], :state => user["state"], :city => user["city"]) if location.blank?
        ass_loc = AssociateLocation.where(:associate_id => @associate.user_id, :start_date => "#{start_date} 00:00:00", :end_date => "#{end_date} 00:00:00").first

        if ass_loc.blank?
          associate_location = AssociateLocation.create(:associate_id => @associate.user_id, :location_id => location.id, :vnet => user["vnet"], :seat_number => user["seat_number"], :start_date => start_date, :end_date => end_date)
        else
          ass_loc.associate_id = @associate.user_id
          ass_loc.location_id = location.id
          ass_loc.vnet = user["vnet"]
          ass_loc.seat_number = user["seat_number"]
          ass_loc.start_date = start_date
          ass_loc.end_date = end_date
          ass_loc.save
        end
        {:location => location, :access_token => @access_token, :status => "success"}.to_json
      else
        {:status => "date_field_empty"}.to_json
      end
    else
      {:status => "failed"}.to_json
    end
  end
  
  get '/locations/new' do
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

  get '/locations' do   
    AssociateLocation.search_associates(params[:search][:associate_name],params[:search][:location]).to_json(:include=>[:associate,:location])
    #~ p AssociateLocation.where("DATE(start_date) = '#{Date.today}'")
  end

  get '/associate' do
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