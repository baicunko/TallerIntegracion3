class SentItemsPedido < ActiveRecord::Base
	require 'geocoder'
	geocoded_by :direccion

   	# :latitude => :lat, :longitude => :lon
	
	after_validation :geocode
end
