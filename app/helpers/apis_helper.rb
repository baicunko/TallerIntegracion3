module ApisHelper
	require 'rest_client'

	def self.pedirProductos(sku, cant)
		RestClient.post 'http://integra5.ing.puc.cl/api', 
		'usuario' => 'grupo3', 
		'password' => '05452d511826a15ba32d6fc4f3562ea75b16db8f', 
		'SKU' => sku, 
		'cantidad' => cant
	end
end
