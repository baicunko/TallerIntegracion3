class StockManagementController < ApplicationController


	def index

	end



	def get_store
		response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/almacenes', 'Authorization' => "UC grupo3:"+generate_hash("GET").to_s
		puts "rrrrrrrrrrrrrrrrrrdfssssssssssssssssssssssssssssssssssssrrrrrrrrrrrrrrrr"+response.to_s
		
	end

	def get_getSkusWithStock
		response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/skusWithStock', 'Authorization' => "UC grupo3:"+generate_hash.to_s
		puts "rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr"+response.to_s
		
	end

	def get_stock
		response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/stock', 'Authorization' => "UC grupo3:"+generate_hash.to_s
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
