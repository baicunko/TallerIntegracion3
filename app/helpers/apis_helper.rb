module ApisHelper
	require 'rest_client'
	require 'json'

	def self.pedirProducto(sku, cant)
		a = 'http://integra4.ing.puc.cl/api/pedirProducto'
		hola=RestClient.post a, 
			'usuario' => 'grupo3', 
			'password' => '05452d511826a15ba32d6fc4f3562ea75b16db8f',
			'almacen_id' => '53571cde682f95b80b7621c1', 
			'SKU' => sku, 
			'cantidad' => cant
		y = JSON.parse(hola)['error']
		p y
				if (!y)
					return
				end

		
		c = 'http://integra8.ing.puc.cl/api/pedirProducto'
		hola1=RestClient.post c, 
			'usuario' => 'grupo3', 
			'password' => '05452d511826a15ba32d6fc4f3562ea75b16db8f',
			'almacen_id' => '53571cde682f95b80b7621c1', 
			'SKU' => sku, 
			'cantidad' => cant
		s = JSON.parse(hola1)[0]['error']
		p s
				if (!s)
					return
				end
		
		b = 'http://integra2.ing.puc.cl/api/pedirProducto'
		hola2=RestClient.post b, 
			'usuario' => 'grupo3', 
			'password' => 'kakQAo46rtCeQSIU96HKmQxUKQU=',
			'almacenId' => '53571cde682f95b80b7621c1', 
			'SKU' => sku, 
			'cantidad' => cant
		t = JSON.parse(hola2)['error']
		p t
				if (!t)
					return
				end

		
	end
end
