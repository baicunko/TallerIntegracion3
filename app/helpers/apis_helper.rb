module ApisHelper
	require 'rest_client'
	require 'json'
	require 'httparty'

	def self.pedirProducto(sku, cant)
		begin 
			stockcontrol = StockManagementController.new
			stockdisp = stockcontrol.getcantidadtotal(sku)
			#p stockdisp

			#e = 'http://integra7.ing.puc.cl/api/api_request'
			#hola6=RestClient.post e, 
			#	'usuario' => 'grupo3', 
			#	'password' => '05452d511826a15ba32d6fc4f3562ea75b16db8f',
			#	'almacen_id' => '53571ce7682f95b80b7685b4', 
			#	'sku' => sku, 
			#	'cantidad' => cant
			#t = JSON.parse(hola6)['error']
			#p t
			#		if (!t)
			#			return
			#		end			

			a = 'http://integra4.ing.puc.cl/api/pedirProducto'
			hola=RestClient.post a, 
				'usuario' => 'grupo3', 
				'password' => '05452d511826a15ba32d6fc4f3562ea75b16db8f',
				'almacen_id' => '53571cde682f95b80b7621c1', 
				'SKU' => sku, 
				'cantidad' => cant
			
			y = JSON.parse(hola)
			p y
					if (!y)
						return
					end

			sleep(2)
			stockdisp = stockcontrol.getcantidadtotal(sku)
			if(stockdisp[0]>=cant)
				return
			else
				hola8= HTTParty.post("http://integra8.ing.puc.cl/api/pedirProducto",
	                            :body => { 	:usuario => 'grupo3',
	                                        :password => 'grupo3',
	                                        :almacen_id => '53571cde682f95b80b7621c1',
	                                        :SKU => sku,
	                                        :cantidad => cant.to_i
	                            }.to_json, :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } )
				s = hola8[0]
				p s
						if (!s)
							return
						end
				sleep(2)
				stockdisp = stockcontrol.getcantidadtotal(sku)
				if(stockdisp[0]>=cant)
					return
				else
					u = "http://integra9.ing.puc.cl/api/pedirProducto/grupo3/HrjVuCJC/#{sku}"
					hola7=RestClient.post u, 
						'usuario' => 'grupo3', 
						'password' => '05452d511826a15ba32d6fc4f3562ea75b16db8f',
						'almacen_id' => '53571cde682f95b80b7621c1', 
						'sku' => sku, 
						'cantidad' => cant
					t = JSON.parse(hola7)
					p t
							if (!t)
								return
							end	
					sleep(2)
					stockdisp = stockcontrol.getcantidadtotal(sku)
					if(stockdisp[0]>=cant)
						return
					else

						d = 'http://integra6.ing.puc.cl/apiGrupo/pedido'
						hola4=RestClient.post d, 
							'usuario' => 'grupo3', 
							'password' => '3',
							'almacen_id' => '53571cde682f95b80b7621c1', 
							'SKU' => sku, 
							'cantidad' => cant
						t = JSON.parse(hola4)
						p t
								if (!t)
									return
								end
						sleep(2)
						stockdisp = stockcontrol.getcantidadtotal(sku)
						if(stockdisp[0]>=cant)
							return
						else
							o = 'http://integra1.ing.puc.cl/ecommerce/api/v1/pedirProducto'
							hola5=RestClient.post o, 
								'usuario' => 'grupo3', 
								'password' => 'grupo3',
								'almacenId' => '53571cde682f95b80b7621c1', 
								'sku' => sku, 
								'cant' => cant
							t = JSON.parse(hola5)
							p t
									if (!t)
										return
									end
							sleep(2)
							stockdisp = stockcontrol.getcantidadtotal(sku)
							if(stockdisp[0]>=cant)
								return
							else		

								z = 'http://integra5.ing.puc.cl/api/v1/pedirProducto'
								hola9=RestClient.post z, 
									'usuario' => 'grupo3', 
									'password' => 'grupo3',
									'almacenId' => '53571cde682f95b80b7621c1', 
									'sku' => sku, 
									'cantidad' => cant
								t = JSON.parse(hola9)
								p t
										if (!t)
											return
										end	
								sleep(2)
								stockdisp = stockcontrol.getcantidadtotal(sku)
								if(stockdisp[0]>=cant)
									return
								else							
									b = 'http://integra2.ing.puc.cl/api/pedirProducto'
									hola3=RestClient.post b, 
										'usuario' => 'grupo3', 
										'password' => 'kakQAo46rtCeQSIU96HKmQxUKQU=',
										'almacen_id' => '53571cde682f95b80b7621c1', 
										'SKU' => sku, 
										'cantidad' => cant
									t = JSON.parse(hola3)
									p t
											if (!t)
												return
											end
								end					
							end												
						end
					end
				end
			end
		rescue => e
			Rails.logger.info "Error al pedir productos a bodegas externas. #{e}"
		end

		
	end
	
end
