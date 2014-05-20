module ApisHelper
	require 'rest_client'
	require 'json'

	def self.pedirProducto(sku, cant)
		3.times do |i|
			a = 'http://integra.ing.puc.cl/api/pedirProducto'
			if (i==1)
				a.insert(14,'4')
			else if (i==2)
				a.insert(14,'5')
			else
				a.insert(14,'8')
			hola=RestClient.post a, 
			'usuario' => 'grupo3', 
			'password' => 'grupo3',
			'almacen_id' => '53571cde682f95b80b7621c1', 
			'SKU' => sku, 
			'cantidad' => cant
			y = JSON.parse(hola)['error']
			if (!y)
				break
			end
		end
	end
end
