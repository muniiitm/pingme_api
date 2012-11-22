# REF: http://www.rubygeocoder.com/
require 'geocoder'
module GeocoderService
# Method to convert Address to Latitude and Longitude
def address_to_latlng(address)
begin
geocoder = Geocoder.search(address)
geocoder[0].address # returns the address which can be used for google maps
geocoder[0].latitude # returns the latitude
geocoder[0].longitude # returns the longitude
rescue Exception => e
# Implement Yahoo geocoder services
end
end
# Method to convert ip address to Latitude and Longitude
def ip_to_latlng(ip)
begin
geocoder = Geocoder.search(ip)
city = geocoder[0].city
country = geocoder[0].country
geocoder[0].latitude
geocoder[0].longitude
rescue Exception => e
# Implement the Yahoo geocoder services
end
end
end
