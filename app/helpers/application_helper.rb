module ApplicationHelper
	def self.rafael
		puts "SOY FEO"
		RAILS_DEFAULT_LOGGER.error("\n test \n")
		p=Spree::Product.find_by_id(4);
	end
end
