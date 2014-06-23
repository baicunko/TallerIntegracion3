module PreciosTemporalsHelper

	def self.crear_tabla
		query = "SELECT sku AS SKU, precio from products where fecha_vigencia>date('now') AND fecha_actualizacion<date('now')"
		results = Product.connection.execute(query)
		results.each do |t|
			product = PreciosTemporal.where(sku: t["sku"])

	      	if product.count == 1
	      		p "EL COUNT ES 1 CONCHAT"
	        	product.first.update_attributes(t.except(0,1)) # exclude the price field.
	      	
	      	else
		        user=PreciosTemporal.new
		        user.sku=t["sku"]
		        user.precio=t["precio"]
		        user.save
			end
		end
	
	end
end
