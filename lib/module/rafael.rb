module ApplicationHelper

	def self.rafael
		p=Spree::Product.find_by_id(4);
		p.description="RAFAEL ES EL AYUDANTE";
		p.save;

	end

end
