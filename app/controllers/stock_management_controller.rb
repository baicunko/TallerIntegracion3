class StockManagementController < ApplicationController
	require 'json'

	def index


	end



	def get_store
		response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/almacenes', 'Authorization' => "UC grupo3:"+generate_hash("GET").to_s
		puts response.length.to_s
		parsed_json = ActiveSupport::JSON.decode(response)
		
		puts parsed_json.length
		(0..parsed_json.length-1).each do |i|
			JSON.parse(parsed_json[i].to_json)
			puts parsed_json[i].to_s #FALTA ACTUALIZAR LOS CAMBIOS!
			Store.where(_id: parsed_json[i]['_id']).first_or_create.update_attributes(lung: parsed_json[i]['pulmon'],dispatch: parsed_json[i]['despacho'] ,reception: parsed_json[i]['recepcion'],used_space:  parsed_json[i]['usedSpace'],total_space: parsed_json[i]['totalSpace']) 

			# store= Store.find(_id:parsed_json[i]['_id'])
			# store.update(lung: parsed_json[i]['pulmon'],dispatch: parsed_json[i]['despacho'] ,reception: parsed_json[i]['recepcion'],used_space: 100 ,total_space: parsed_json[i]['totalSpace'])
			# puts parsed_json[i].to_s
			# puts parsed_json[i]['grupo'].to_s()
			# parsed_json2 = ActiveSupport::JSON.decode(parsed_json)
			# puts parsed_json[i].[_id]
		end

		@stores=Store.all
		response
	end

	def get_skuswithstock(almacen_id)
		response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/skusWithStock?almacenId='+almacen_id.to_s,'Authorization' => "UC grupo3:"+generate_hash("GET"+almacen_id.to_s)
		puts response.to_s
		parsed_json = ActiveSupport::JSON.decode(response)
		(0..parsed_json.length-1).each do |i|
			JSON.parse(parsed_json[i].to_json)
			puts parsed_json[i].to_s #FALTA ACTUALIZAR LOS CAMBIOS!
			StockInStore.where(sku: parsed_json[i]['_id'], store_id: almacen_id).first_or_create.update_attributes(stock: parsed_json[i]['total']) 
		
		response	# store= Store.find(_id:parsed_json[i]['_id'])
		end
	end

	def actualizar_skus_with_stock_total
		@store=Store.all
		@store.each do |s|
			get_skuswithstock(s._id)
		end
	end

	def get_stock(almacen_id,sku)#falta otro igual con el opcional
		response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/stock?almacenId='+almacen_id.to_s+'&sku='+sku.to_s, 'Authorization' => "UC grupo3:"+generate_hash("GET"+almacen_id.to_s+sku.to_s)
		puts response.to_s
		parsed_json = ActiveSupport::JSON.decode(response)
		(0..parsed_json.length-1).each do |i|
			JSON.parse(parsed_json[i].to_json)
			Product.where(_id: parsed_json[i]['_id']).first_or_create.update_attributes(store_id: parsed_json[i]['almacen'],sku:parsed_json[i]['sku'],direccion: parsed_json[i]['direccion'],despachado:parsed_json[i]['despachado'] )	
		response
		end
	end

	def move_stock(producto_id, almacen_id)
		response= HTTParty.post("http://bodega-integracion-2014.herokuapp.com/moveStock",
    	:body => { 	:productoId => producto_id, 
    				:almacenId => almacen_id
    				},
    	:headers => { "Authorization" => "UC grupo3:"+generate_hash('POST'+producto_id.to_s+almacen_id.to_s)})
		



		# response= RestClient.post 'http://bodega-integracion-2014.herokuapp.com/moveStock',
		# {:params => {'productoId' => producto_id ,'almacenId' => almacen_id,
		# 'Authorization' => "UC grupo3:"+generate_hash('POST'+producto_id.to_s+almacen_id.to_s)}}

		# RestClient.post Integra2::STOCK_API_URL+'moveStock', {:Authorization => generate_auth_hash('POST'+producto.to_s+almacen.to_s), :params=>{:almacenId=>almacen, :productoId=>producto}}
		# # 'productoId' => producto_id , 'almacenId'=> almacen_id ,'Authorization' => "UC grupo3:"+generate_hash("POST"+producto_id.to_s+almacen_id.to_s).to_s
		# #?productoId='+producto_id.to_s+'&almacenId='+almacen_id.to_s
		# @result = HTTParty.post(@urlstring_to_post.to_str, 
  #   :body => { :subject => 'This is the screen name', 
  #              :issue_type => 'Application Problem', 
  #              :status => 'Open', 
  #              :priority => 'Normal', 
  #              :description => 'This is the description for the problem'
  #            }.to_json,
  #   :headers => { 'Content-Type' => 'application/json' } )
	end

	def move_stock_to_warehouse(producto_id,almacen_id)
		response= HTTParty.post('http://bodega-integracion-2014.herokuapp.com/moveStockBodega',
		:body => { 	:productoId => producto_id, 
    				:almacenId => almacen_id
    				},
    	:headers => { "Authorization" => "UC grupo3:"+generate_hash('POST'+producto_id.to_s+almacen_id.to_s)})
		
		puts response.to_s
		
	end
	def dispatch_stock(producto_id,direccion,precio,pedido_id) #DELETE
		response= HTTParty.delete('http://bodega-integracion-2014.herokuapp.com/stock',
		:body => { 	:productoId => producto_id, 
						:direccion => direccion,
						:precio	=> precio,
						:pedidoId => pedido_id					
					},
    	:headers => { "Authorization" => "UC grupo3:"+generate_hash('DELETE'+producto_id.to_s+direccion.to_s+precio.to_s+pedido_id.to_s)})

		puts response.to_s
		
	end

	def total_sku_stock(sku)
		suma=0
		@storesku = StockInStore.find(:all, :conditions => ["sku = ? ", sku])
		@storesku.each do |s|
			@storesku
			suma += @storesku.stock
		
			
		end		
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
