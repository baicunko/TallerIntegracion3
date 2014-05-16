class StockManagementController < ApplicationController
	require 'json'

	def index

	end



	def get_store
		response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/almacenes', 'Authorization' => "UC grupo3:"+generate_hash("GET").to_s
		puts response.length.to_s
		parsed_json = ActiveSupport::JSON.decode(response)
		respuesta=response.to_json
		puts parsed_json.length
		(0..parsed_json.length-1).each do |i|
			JSON.parse(parsed_json[i].to_json)
			puts parsed_json[i].to_s #FALTA ACTUALIZAR LOS CAMBIOS!
			Store.where(_id: parsed_json[i]['_id']).first_or_create(lung: parsed_json[i]['pulmon'],dispatch: parsed_json[i]['despacho'] ,reception: parsed_json[i]['recepcion'],used_space:  parsed_json[i]['usedSpace'],total_space: parsed_json[i]['totalSpace']) 
			# store= Store.find(_id:parsed_json[i]['_id'])
			# store.update(lung: parsed_json[i]['pulmon'],dispatch: parsed_json[i]['despacho'] ,reception: parsed_json[i]['recepcion'],used_space: 100 ,total_space: parsed_json[i]['totalSpace'])
			# puts parsed_json[i].to_s
			# puts parsed_json[i]['grupo'].to_s()
			# parsed_json2 = ActiveSupport::JSON.decode(parsed_json)
			# puts parsed_json[i].[_id]
		end
	end

	def get_getSkusWithStock(almacen_id)
		response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/skusWithStock?almacenId='+almacen_id.to_s,'Authorization' => "UC grupo3:"+generate_hash("GET"+almacen_id.to_s)
		puts "rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"+response.to_s
		
	end

	def get_stock(almacen_id,sku)#falta otro igual con el opcional
		response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/stock?almacenId='+almacen_id.to_s+'&sku='+sku.to_s, 'Authorization' => "UC grupo3:"+generate_hash("GET"+almacen_id.to_s+sku.to_s)
		puts "rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"+response.to_s
		
	end

	def move_stock
		response= RestClient.post 'http://bodega-integracion-2014.herokuapp.com/moveStock', 'Authorization' => "UC grupo3:"+generate_hash.to_s
		puts "rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"+response.to_s
		
	end

	def move_stock_to_warehouse
		response= RestClient.post 'http://bodega-integracion-2014.herokuapp.com/moveStockBodega', 'Authorization' => "UC grupo3:"+generate_hash.to_s
		puts "rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"+response.to_s
		
	end
	def dispatch_stock #DELETE
		response= RestClient.post 'http://bodega-integracion-2014.herokuapp.com/stock', 'Authorization' => "UC grupo3:"+generate_hash.to_s
		puts "rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"+response.to_s
		
	end

	def generate_hash(pedido)
		require 'openssl'
		require "base64"

 
		hash  = OpenSSL::HMAC.digest('sha1', "deysq0yt", pedido.to_s)
		
		auth=Base64.encode64(hash)
		

	end

	def add_store
		user = @enterprise.users.build(user_params)
		if @enterprise.save
			render json: { success: 'Usuario creado exitosamente', name: user.full_name, url: user_path(user) }
		else
			render json: { error: 'No se pudo crear el usuario' }
		end
	end

end
