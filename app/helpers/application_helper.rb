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
    ProcesarPedidos



  end

  def self.ProcesarPedidos
    #Cada 10 minutos este metodo se debe llamar
    stockController=StockManagementController.new
    stockController.get_store
    Reserva.consumir
    FtpPedido.verPedidos;
    sql = "SELECT * from ftp_pedidos WHERE entrega >= DATE ('now') AND envio IS NULL AND id=2625 GROUP BY id ORDER BY entrega"
    records_array = FtpPedido.connection.execute(sql)

    records_array.each do |tupla|

      quiebre=false;
      pedido=FtpPedido.where(id: tupla["id"])
      pedido.each do |tuplaEspecial|

        stockDisponible=stockController.getcantidadtotal(tuplaEspecial["sku"])
        if(stockDisponible>=tuplaEspecial["cantidad"].to_i && stockDisponible-tuplaEspecial["cantidad"].to_i>=Reserva.stockReservado(tuplaEspecial["sku"]))

        else
          quiebre=true;
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
          quiebrerecord.save
        end

      else #estos son los pedidos sin quiebre! Si o si existe stock
          pedido.each do |tuplaPedidoEnviar|
          precio=PreciosTemporal.where[SKU:tuplaPedidoEnviar["sku"]]
          direccion=Contact.queryDireccion(tuplaPedidoEnviar["direccion"])
          stockController.mover_a_despacho_sku(tuplaPedidoEnviar["sku"],tuplaPedidoEnviar["cantidad"])
          stockController.despachar_sku(tuplaPedidoEnviar["sku"],tuplaPedidoEnviar["cantidad"],precio,direccion,tupla["id"])

        end
















      end




    end




  end
end




