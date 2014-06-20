module ApplicationHelper
  APP_KEY="ic0hidmnoxyvp9q"
  APP_SECRET="n80ou9i5e4u9iix"
  require 'dropbox_sdk'
  require 'json'
  require 'TuitterHelper.rb'
  def self.connect
    code = "wsWFRrcC0rkAAAAAAAAAC925LJBoi7yUZFXn2NyLtuqLapTzJqvoPCav4Pm4sIys"
    client = DropboxClient.new(code)
    puts "linked account:", client.account_info().inspect
    contents, metadata = client.get_file_and_metadata('/Grupo3/DBPrecios.accdb')

    destination_file_full_path = Rails.root.to_s + "/app/" + "products.accdb"
    open(destination_file_full_path, 'wb') do |file|
      file << contents
    end

    #ya tenemos cargado entonces el Access, ahora pasemoslo a csv
    access2csv=Rails.root.to_s + "/app/"
    comando="/usr/bin/java -jar "+access2csv+"access2csv.jar "+access2csv+"products.accdb";
    system(comando);

    LoadingHelper.import;
    LoadingHelper.importProductosJson;
    PreciosTemporalsHelper.crear_tabla;
    UsuariosClavesApi.usuarios_claves




  end

  def self.procesarpedido
    #Cada 10 minutos este metodo se debe llamar


    stockController=StockManagementController.new
    stockController.get_store
    stockController.liberar_recepcion
    Reserva.consumir
    FtpPedido.verPedidos;
    sql="SELECT * from ftp_pedidos WHERE entrega <= DATE ('now') AND envio IS NULL GROUP BY id";
    records_array = FtpPedido.connection.execute(sql)


    records_array.each do |tupla|

      quiebre=false;
      pedido=FtpPedido.where(id: tupla["id"])
      pedido.each do |tuplaEspecial|

        stockDisponible=stockController.getcantidadtotal(tuplaEspecial["sku"])
        if(stockDisponible>=tuplaEspecial["cantidad"].to_i)
          #Ahora tengo que ver si es que la persona que hizo el pedido tiene reserva
          reservasmias, reservasotros=Reserva.stockReservado(tuplaEspecial["sku"].to_s,tuplaEspecial.cantidad.to_i,tuplaEspecial["rut"])
          p reservasmias
          p reservasotros
          if(reservasmias==0 && reservasotros<stockDisponible) #caso cuando no he reservado pero si alcanza

          else
            quiebre=true


          end
          if(reservasmias>0)
            quiebre=false

            Reserva.updateutilizado(tuplaEspecial["sku"],tuplaEspecial.cantidad.to_i,tuplaEspecial["rut"])

          end








        else
          quiebre=true;
          executarenSql="UPDATE ftp_pedidos SET envio=Date('now') WHERE id="+tupla["id"]
          FtpPedido.connection.execute(executarenSql)
          #ApisHelper.pedirProducto(tuplaEspecial["sku"],tuplaEspecial.cantidad.to_i)
        end

      end
      if(quiebre)
        #poner cantidad
        quiebreClass=Quiebre.where(id: tupla["id"])
        if(quiebreClass.count==0)
          quiebrerecord=Quiebre.new
          quiebrerecord.nombrecliente=Contact.query(tupla["direccion"])
          quiebrerecord.fechaquiebre=Time.now
          quiebrerecord.pedido=tupla["id"];
          costo=0
=begin
          pedido.each do |j|
            precio=PreciosTemporal.where(SKU:pedido["sku"])
            cantidadComprada=j.cantidad.to_i
            costo=costo+(precio*cantidadComprada)


          end
          quiebre.dineroperdido=costo;
          quiebrerecord.save




=end      quiebre.dineroperdido=0;
          quiebrerecord.save
        end

      else #estos son los pedidos sin quiebre! Si o si existe stock
        pedido.each do |tuplaPedidoEnviar|
          precio=PreciosTemporal.where(SKU:tuplaPedidoEnviar["sku"])
          direccion=Contact.queryDireccion(tuplaPedidoEnviar["direccion"])
          cantidad=tuplaPedidoEnviar.cantidad
          cantidadInteger=cantidad.to_i
          precioInteger=precio[0].precio
          stockController.mover_a_despacho_sku(tuplaPedidoEnviar["sku"],cantidadInteger)
          stockController.despachar_sku(tuplaPedidoEnviar["sku"],cantidadInteger,precioInteger,direccion,tupla["id"])

        end

      end




    end




  end

  def self.spreeIntegration

    #Tengo que actualizar los stocks en el spree
    stockEnSpree= HTTParty.get("http://localhost:3000/store/api/stock_locations/1/stock_items?token=2d322b9538440950685ad9c4d0d35bec9f670c9b0c01d5c4&per_page=3000")
    b=StockManagementController.new

    $stockAlmacen1=b.get_skuswithstock(Store.find(1)._id);
    $stockAlmacen2=b.get_skuswithstock(Store.find(2)._id);
    $stockAlmacen3=b.get_skuswithstock(Store.find(3)._id);
    $stockAlmacen4=b.get_skuswithstock(Store.find(4)._id);
    $stockAlmacen5=b.get_skuswithstock(Store.find(5)._id);

    stockEnSpree['stock_items'].each do |producto|
      countstock=0
      countstock+=stockPorSKU(producto['variant']['sku'],$stockAlmacen1)
      countstock+=stockPorSKU(producto['variant']['sku'],$stockAlmacen2)
      countstock+=stockPorSKU(producto['variant']['sku'],$stockAlmacen3)
      countstock+=stockPorSKU(producto['variant']['sku'],$stockAlmacen4)
      countstock+=stockPorSKU(producto['variant']['sku'],$stockAlmacen5)
      if(countstock!=producto['count_on_hand'])
        #Significa que hay diferencias con el spree
        #Actualizo sin API, es mas rapido
        b=Spree::StockItem.find(producto['id'])
        b['count_on_hand']=countstock
        b.save




      end

      #Tengo que buscar  el stock

    end

  end
  def self.backOrderFalse

    @todos=Spree::StockItem.all
    @todos.each do |producto|
      producto['backorderable']=false
      producto.save
    end
  end

  def self.stockPorSKU(sku,jsonParseadoAlmacen)
    total=0;

    (0..jsonParseadoAlmacen.length-1).each do |i|
      JSON.parse(jsonParseadoAlmacen[i].to_json)
      if(jsonParseadoAlmacen[i]['_id']==sku)
        total=total+jsonParseadoAlmacen[i]['total'].to_i
      end
    end
    return total


  end
  def self.procesarPedidosSpree
    #primero capture
    #http://localhost:3000/store/api/orders/R156162404/payments/5/capture?token=2d322b9538440950685ad9c4d0d35bec9f670c9b0c01d5c4&per_page=100000
    #Depsues usando el order number saco el shipment number http://localhost:3000/store/api/orders/R156162404?token=2d322b9538440950685ad9c4d0d35bec9f670c9b0c01d5c4&per_page=100000
    #por ultimo ship http://localhost:3000/store/api/orders/R156162404/shipments/H35327667308/ship?token=2d322b9538440950685ad9c4d0d35bec9f670c9b0c01d5c4&per_page=100000
    #primero en verdad hay que sacar todas las ordenes que esten en estado complete
    ordenes= HTTParty.get("http://localhost:3000/store/api/orders?token=2d322b9538440950685ad9c4d0d35bec9f670c9b0c01d5c4&per_page=20000")
    ordenes['orders'].each do |ordenRevisar|
      if(ordenRevisar['state'].to_s=="complete" && ordenRevisar['shipment_state'].to_s!="shipped")
        #la orden esta en estado completa, tengo que capturar primero
        linkCapturar="http://localhost:3000/store/api/orders/"+ordenRevisar['number'].to_s+"/payments/"+ordenRevisar['id'].to_s+"/capture?token=2d322b9538440950685ad9c4d0d35bec9f670c9b0c01d5c4"
        respuestaCapture=HTTParty.put(linkCapturar)
        #Ahora que tengo capturado el metodo de pago, tengo que sacar el shipment number
        linkShipment="http://localhost:3000/store/api/orders/"+ordenRevisar['number'].to_s+"?token=2d322b9538440950685ad9c4d0d35bec9f670c9b0c01d5c4"
        respuestaLinkShipment=HTTParty.get(linkShipment)
        #Ahora puedo sacar el shipment number que me sirve para marcar una orden como enviada
        linkShip="http://localhost:3000/store/api/orders/"+ordenRevisar['number'].to_s+"/shipments/"+respuestaLinkShipment['shipments'][0]['number'].to_s+"/ship?token=2d322b9538440950685ad9c4d0d35bec9f670c9b0c01d5c4"
        shipmentNumber=HTTParty.put(linkShip)
        #Listo! Con esto tenemos que se envio el pedido, solo me falta integrarlo con la api de envio de stock y no habria problemas.
        #Agregar valor metiendo las transacciones en las mismas tablas que usamos pa los ftp pedidos

      end
    end

  end
  def self.mandarATwitter(mensaje)
    TuitterHelper.sendTweet(mensaje)
  end





end




