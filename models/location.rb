class Location < ActiveRecord::Base
  has_many :associates,:through => :associate_location

  def self.start_and_end_date(date_range, start_date, end_date)
    if date_range == 'week'
      start_date = Date.today.beginning_of_week.strftime("%Y-%m-%d")
      end_date = Date.today.end_of_week.strftime("%Y-%m-%d")
    elsif date_range == 'today'
      start_date = DateTime.now.strftime("%Y-%m-%d")
      end_date = "#{start_date}"
    else
      start_date = user["start_date"]
      end_date = user["end_date"]
    end

    return "#{start_date} 00:00:00", "#{end_date} 00:00:00"
  end

  def self.create_location(address, country, city, state)
    location = Location.find_or_create_by_country_and_city_and_state(country, city, state)
    location.address = address
    location.save
  end

  def self.get_all_address
    locations = Location.all
    addresses = locations.map(&:address).uniq.reject { |a| a.nil? }
    countries = locations.map(&:country).uniq.reject { |c| c.nil? }
    states = locations.map(&:state).uniq.reject { |s| s.nil? }
    cities = locations.map(&:city).uniq.reject { |c| c.nil? }

    return addresses, countries, states, cities
  end

  def self.get_all_lat_and_lon
    location = Location.all
    lat = location.map(&:latitude).reject {|e| e.nil? }
    lon = location.map(&:longitude).reject {|e| e.nil? }

    return lat, lon
  end
end