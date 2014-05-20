module ApplicationHelper
  APP_KEY="ic0hidmnoxyvp9q"
  APP_SECRET="n80ou9i5e4u9iix"
  require 'dropbox_sdk'

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




  end

  def self.procesarpedido
    #Cada 10 minutos este metodo se debe llamar

    stockController=StockManagementController.new
    stockController.get_store
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
          ApisHelper.pedirProducto(tuplaEspecial["sku"],tuplaEspecial.cantidad.to_i)
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
          pedido.each do |j|
            precio=PreciosTemporal.where(SKU:pedido["sku"])
            cantidadComprada=j.cantidad.to_i
            costo=costo+(precio*cantidadComprada)


          end
          quiebre.dineroperdido=costo;
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
end




