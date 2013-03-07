class App < Sinatra::Base

  # Move the logics into model
  post '/associates/location' do
    user = params[:user]
    if @flag
      start_date, end_date = Location.start_and_end_date(user['date_range'], user['start_date'], user['end_date'])

      # create the location
      location = Location.create_location(user['location'], user['country'], user['city'], user['state'])

      # create the associate location
      associate_location = AssociateLocation.create_associate_location(@associate.id, location.id, start_date, end_date, vnet, seat_number)

      # to update the latitude and longitude
      update_lat_and_lon(location)

      {:location => location, :access_token => @access_token, :status => "success"}.to_json
    else
      {:status => "failed"}.to_json
    end
  end

  get '/locations/new' do
    if @flag
      addresses, countries, states, cities = Location.get_all_address
      {:addresses => addresses, :countries => countries, :states => states, :cities => cities, :access_token => @access_token, :status => "success"}.to_json
    else
      {:status => "failed"}.to_json
    end
  end

  # get latitude and longitude information for all address from location table.
  get '/locations/latitude_and_longitude' do
    if @flag
      lat, lon = Location.get_all_lat_and_lon
      lat_and_lon = lat.zip(lon)
      {:lat_and_lon => lat_and_lon, :access_token => @access_token, :status => "success"}.to_json
    else
      {:status => "failed"}.to_json
    end
  end

  get '/locations' do
    search_key = generate_search_query
    AssociateLocation.search_associates(params[:search][:associate_name],search_key ,params[:search][:location]).to_json(:include=>[:associate,:location])
  end

  get '/associates/total' do
    associates = Associate.count
    {:associates => associates, :status => "success"}.to_json
  end

  def generate_search_query
    date = Date.today
    case params[:search][:time_period]
      when "today"
        search_date = "DATE(start_date) or DATE(end_date) = '#{date}'"
      when "this week"
      search_date =  "Date(start_date) between '#{date.beginning_of_week}' and '#{date.end_of_week}' or Date(end_date) between '#{date.beginning_of_week}' and '#{date.end_of_week}' "
      when "next week"
        date = (Date.today.end_of_week + 1)
        search_date =  "Date(start_date) between '#{date.beginning_of_week}' and '#{date.end_of_week}' or Date(end_date) between '#{date.beginning_of_week}' and '#{date.end_of_week}' "
    end
    search_key = "associates.first_name LIKE ? and locations.city LIKE ?"
    search_key << "and (#{search_date })" unless search_date.nil?
    return search_key
  end

end