class StockManagementController < ApplicationController


  require 'json'



  def get_store
    response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/almacenes', 'Authorization' => "UC grupo3:"+generate_hash("GET").to_s
    # puts response.length.to_s
    parsed_json = ActiveSupport::JSON.decode(response)
    # puts parsed_json.length
    (0..parsed_json.length-1).each do |i|
      JSON.parse(parsed_json[i].to_json)
      # puts parsed_json[i].to_s #FALTA ACTUALIZAR LOS CAMBIOS!
      Store.where(_id: parsed_json[i]['_id']).first_or_create.update_attributes(lung: parsed_json[i]['pulmon'],dispatch: parsed_json[i]['despacho'] ,reception: parsed_json[i]['recepcion'],used_space:  parsed_json[i]['usedSpace'],total_space: parsed_json[i]['totalSpace'])

		
    end # @stores=get_skuswithstock(params[:almacen_id])
		return parsed_json
	
  end










  def get_skuswithstock(almacen_id)
    response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/skusWithStock?almacenId='+almacen_id.to_s,'Authorization' => "UC grupo3:"+generate_hash("GET"+almacen_id.to_s)
    # puts response.to_s
    parsed_json = ActiveSupport::JSON.decode(response)
    (0..parsed_json.length-1).each do |i|
      JSON.parse(parsed_json[i].to_json)
      # puts parsed_json[i].to_s #FALTA ACTUALIZAR LOS CAMBIOS!
      # StockInStore.where(sku: parsed_json[i]['_id'], store_id: almacen_id).first_or_create.update_attributes(stock: parsed_json[i]['total'])

      # store= Store.find(_id:parsed_json[i]['_id'])
    end
    return parsed_json
  end


  def actualizar_skus_with_stock_total
    @store=Store.all
    @store.each do |s|
      get_skuswithstock(s._id)
    end
  end

  def get_stock(almacen_id,sku)#falta otro igual con el opcional
    response= RestClient.get 'http://bodega-integracion-2014.herokuapp.com/stock?almacenId='+almacen_id.to_s+'&sku='+sku.to_s, 'Authorization' => "UC grupo3:"+generate_hash("GET"+almacen_id.to_s+sku.to_s)
    parsed_json = ActiveSupport::JSON.decode(response)
    (0..parsed_json.length-1).each do |i|
      JSON.parse(parsed_json[i].to_json)
      # 	# Product.where(_id: parsed_json[i]['_id']).first_or_create.update_attributes(store_id: parsed_json[i]['almacen'],sku:parsed_json[i]['sku'],direccion: parsed_json[i]['direccion'],despachado:parsed_json[i]['despachado'] )

    end
    return parsed_json
  end

  def move_stock(producto_id, almacen_id)
    response= HTTParty.post("http://bodega-integracion-2014.herokuapp.com/moveStock",
                            :body => { 	:productoId => producto_id,
                                        :almacenId => almacen_id
                            },
                            :headers => { "Authorization" => "UC grupo3:"+generate_hash('POST'+producto_id.to_s+almacen_id.to_s)})

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




  @almacen1
  @almacen2
  @almacen3
  @almacen4
  @almacen5
  @conexion=false;

  def index


  end




  def getcantidadtotal(sku)
    total=0

    @almacen1=get_stock(Store.find(1)._id,sku)
    total+=@almacen1.length
    #puts "Almacen 1:"+ @almacen1.length.to_s
    @almacen2=get_stock(Store.find(2)._id,sku)
    total+=@almacen2.length
    #puts "Almacen 2:"+ @almacen2.length.to_s
    @almacen3=get_stock(Store.find(3)._id,sku)
    #puts "Almacen 3:"+ @almacen3.length.to_s
    total+=@almacen3.length
    @almacen4=get_stock(Store.find(4)._id,sku)
    total+=@almacen4.length
    #puts "Almacen 4:"+ @almacen4.length.to_s
    @almacen5=get_stock(Store.find(5)._id,sku)
    #puts "Almacen 5:"+ @almacen5.length.to_s
    total+=@almacen5.length

    total
  end

  def mover_a_despacho_sku(sku,cantidad)
    puts "ESTOY EN MOVER DESPACHO"
    puts "Me mandaron "+cantidad.to_s
    puts "Y el SKU ES"+sku.to_s
    i=0
    if(i<=cantidad)
      (2..5).each do |a|
        @almacen=get_stock(Store.find(a)._id,sku)
        puts @almacen.length
        (0..@almacen.length-1).each do |j|
          if (@almacen[j]['despachado']==false)
            puts @almacen[j]['despachado'].to_s
            move_stock(@almacen[j]['_id'],Store.find(1)._id)
            i+=1
            puts i.to_s
            return if (i == cantidad)
            p "SE ACABO EL METODO"
          end
        end
      end
    end
  end


  def despachar_sku(sku,cantidad,precio,direccion, pedido_id)#NO ESTÁ PROBADO

    i=0
    p " ACABO DE ENTRAR A DESPACHAAAR"
    p sku
    p cantidad
    p precio
    p direccion
    p pedido_id


    @despacho=get_stock(Store.find(1)._id,sku)
    (0..@despacho.length-1).each do |j|
      if (@despacho[j]['despachado']==false)
        puts @despacho[j]['despachado'].to_s
        respuestaServidor=dispatch_stock(@despacho[j]['_id'],direccion,precio,pedido_id)
        puts "SEEEERVEEER"
        puts respuestaServidor
        puts "SEERRVEEEER"
        SentItemsPedido.where(sku:sku,cantidad:cantidad,precio:precio,direccion:direccion,pedidoid:pedido_id,respuesta:respuestaServidor).first_or_create(sku:sku,cantidad:cantidad,precio:precio,direccion:direccion,pedidoid:pedido_id,respuesta:respuestaServidor)
        i+=1
        if (i == cantidad)
          break
        end
        puts i.to_s

        p "SE ACABO EL METOOOODOOOOO"
      end
    end

  end

  def despachar_sku_para_grupos(sku,cantidad,almacen_id)
    @despacho=get_stock(Store.find(1)._id,sku)
    (0..cantidad-1).each do |i|
      (0..@despacho.length-1).each do |j|
        if (@despacho[j]['despachado']==false)
          puts @despacho[j]['despachado'].to_s
          move_stock_to_warehouse(@despacho[j]['_id'],almacen_id)
          i+=1
          if (i == cantidad)
            break
          end
          puts i.to_s
        end
      end
    end
  end

  def liberar_recepcion
    # get_skuswithstock
    @stock_recepcion=get_skuswithstock(Store.find(2)._id)
    puts @stock_recepcion.length
    (0..@stock_recepcion.length-1).each do |rec|# (@stock_recepcion.usedSpace>0)
      puts "Recepción tiene cosas todavia"
      @almacenes=get_store
      puts @stock_recepcion[rec]['total']
      puts @stock_recepcion[rec]['_id']
      if(@almacenes[2]['usedSpace']<(@almacenes[2]['totalSpace']+@stock_recepcion[rec]['total']))
        @prods=get_stock(Store.find(2)._id,@stock_recepcion[rec]['_id'])   
        puts "CABE"
        @prods.each do |prod|
          puts prod['_id']
          move_stock(prod['_id'],Store.find(3)._id)
          puts "Producto Movido"
        end
      else
        @prods=get_stock(Store.find(2)._id,@stock_recepcion[rec]['_id'])   
        puts "CABE en Pulmon"
        @prods.each do |prod|
          puts prod['_id']
          move_stock(prod['_id'],Store.find(4)._id)
        end
      end
    end
      # move_stock(@almacen[j]['_id'],Store.find(1)._id
  end

end





