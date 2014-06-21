module ApisHelper
	require 'rest_client'
	require 'json'
	require 'httparty'

	def self.pedirProducto(sku, cant)
		begin 
			stockcontrol = StockManagementController.new
			stockdisp = stockcontrol.total_sku_stock(sku)
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

			sleep(2)
			stockdisp = stockcontrol.total_sku_stock(sku)
			if(stockdisp>=cant)
				return
			else
				hola8= HTTParty.post("http://integra8.ing.puc.cl/api/pedirProducto",
	                            :body => { 	:usuario => 'grupo3',
	                                        :password => 'JJy/cF6c1lDmI9rVmWoanKn2CD4=\n',
	                                        :almacen_id => '53571e21682f95b80b78107d',
	                                        :SKU => sku,
	                                        :cantidad => cant
	                            }.to_json, :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } )
				#s = JSON.parse(hola8)[0]['error']
				p hola8
				#		if (!s)
				#			return
				#		end
				sleep(2)
				stockdisp = stockcontrol.total_sku_stock(sku)
				if(stockdisp>=cant)
					return
				else
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
					sleep(2)
					stockdisp = stockcontrol.total_sku_stock(sku)
					if(stockdisp>=cant)
						return
					else

						d = 'http://integra6.ing.puc.cl/api/pedirProducto'
						hola2=RestClient.post b, 
							'usuario' => 'grupo3', 
							'password' => 'kakQAo46rtCeQSIU96HKmQxUKQU=',
							'almacen_id' => '53571cde682f95b80b7621c1', 
							'SKU' => sku, 
							'cantidad' => cant
						t = JSON.parse(hola2)['error']
						p t
								if (!t)
									return
								end
					end
				end
			end
		rescue => e
			Rails.logger.info "Error al pedir productos a bodegas externas. #{e}"
		end

		
	end
	
end
