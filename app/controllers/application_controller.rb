class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	require 'csv'    

	def excel_import
		CSV.foreach('/Users/joaquinzavala/Desktop/Libro1.csv', :headers => true) do |row|
		  Moulding.create!(row.to_hash)
		end
	end

end
