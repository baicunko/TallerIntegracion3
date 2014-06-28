  class Probando
    include HTTParty
    default_timeout 10000000

  end

  module ApplicationHelper
    APP_KEY="ic0hidmnoxyvp9q"
    APP_SECRET="n80ou9i5e4u9iix"
    require 'dropbox_sdk'
    require 'json'
    require 'TuitterHelper.rb'
    require 'rubygems'



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
      PreciosTemporalsHelper.crear_tabla;
      UsuariosClavesApi.usuarios_claves




    end
    def self.importarJson
      #Llamarlo una vez nomas
      LoadingHelper.importProductosJson;
    end

    def self.procesarpedido
      #Cada 30 minutos este metodo se debe llamar


      stockController=StockManagementController.new
      stockController.get_store
      stockController.liberar_recepcion
      Q
      FtpPedido.verPedidos;
      sql="SELECT * from ftp_pedidos WHERE entrega <= DATE ('now') AND envio IS NULL";
      records_array = FtpPedido.connection.execute(sql)


      records_array.each do |tuplaEspecial|





          stockDisponible=stockController.getcantidadtotal(tuplaEspecial["sku"]).to_i
          if(stockDisponible>=tuplaEspecial["cantidad"].to_i)
            #Ahora tengo que ver si es que la persona que hizo el pedido tiene reserva
            reservasmias, reservasotros=Reserva.stockReservado(tuplaEspecial["sku"].to_s,tuplaEspecial["cantidad"].to_i,tuplaEspecial["rut"])
            if(reservasmias==0 && tuplaEspecial["cantidad"].to_i<=stockDisponible-reservasotros) #Le envio las cosas a Cox
              precio=PreciosTemporal.where(SKU:tuplaEspecial["sku"])
              direccion=Contact.queryDireccion(tuplaEspecial["direccion"])
              cantidadInteger=tuplaEspecial["cantidad"].to_i
              precioInteger=precio[0].precio
              stockController.mover_a_despacho_sku(tuplaEspecial["sku"],cantidadInteger)
              stockController.despachar_sku(tuplaEspecial["sku"],cantidadInteger,precioInteger,direccion,tuplaEspecial["id"])
            elsif(reservasmias==0 && tuplaEspecial["cantidad"].to_i>stockDisponible.to_i-reservasotros && stockDisponible-reservasotros>=0)
              diferenciaProductos=reservasotros+tuplaEspecial["cantidad"].to_i-stockDisponible
              ApisHelper.pedirProducto(tuplaEspecial["sku"],diferenciaProductos)
              #Aca yo puedo mandarle al cliente el stock disponible menos las reservas
              precio=PreciosTemporal.where(SKU:tuplaEspecial["sku"])
              direccion=Contact.queryDireccion(tuplaEspecial["direccion"])
              cantidadInteger=stockDisponible.to_i-reservasotros.to_i
              precioInteger=precio[0].precio
              stockController.mover_a_despacho_sku(tuplaEspecial["sku"],cantidadInteger)
              stockController.despachar_sku(tuplaEspecial["sku"],cantidadInteger,precioInteger,direccion,tuplaEspecial["id"])
              sleep(2)
              stockDisponible2=stockController.getcantidadtotal(tuplaEspecial["sku"]).to_i
              if(diferenciaProductos>stockDisponible2.to_i-stockDisponible.to_i)
                #Me llegaron los productos faltantes, los mando
                precio=PreciosTemporal.where(SKU:tuplaEspecial["sku"])
                direccion=Contact.queryDireccion(tuplaEspecial["direccion"])
                cantidadInteger=diferenciaProductos
                precioInteger=precio[0].precio
                stockController.mover_a_despacho_sku(tuplaEspecial["sku"],cantidadInteger)
                stockController.despachar_sku(tuplaEspecial["sku"],cantidadInteger,precioInteger,direccion,tuplaEspecial["id"])
              else
                #hubo quiebre
                #primero veo si puedo mandar algo de lo que me llego
                if(stockDisponible2-stockDisponible>0)
                  #significa que puedo mandar algo
                  precio=PreciosTemporal.where(SKU:tuplaEspecial["sku"])
                  direccion=Contact.queryDireccion(tuplaEspecial["direccion"])
                  cantidadInteger=stockDisponible2-stockDisponible
                  precioInteger=precio[0].precio
                  stockController.mover_a_despacho_sku(tuplaEspecial["sku"],cantidadInteger)
                  stockController.despachar_sku(tuplaEspecial["sku"],cantidadInteger,precioInteger,direccion,tuplaEspecial["id"])
                  #Y tengo que hacer un quiebre por lo que me falto.
                  quiebrerecord=Quiebre.new
                  quiebrerecord.nombrecliente=Contact.query(tuplaEspecial["direccion"])
                  quiebrerecord.fechaquiebre=Time.now
                  quiebrerecord.pedido=tuplaEspecial["id"]
                  quiebrerecord.sku=tuplaEspecial["sku"].to_s
                  quiebrerecord.cantidad=diferenciaProductos.to_i-(stockDisponible2-stockDisponible).to_i
                  quiebrerecord.dineroperdido=(diferenciaProductos-(stockDisponible2-stockDisponible))*precio
                  quiebrerecord.save

                else
                  quiebrerecord=Quiebre.new
                  quiebrerecord.nombrecliente=Contact.query(tuplaEspecial["direccion"])
                  quiebrerecord.fechaquiebre=Time.now
                  quiebrerecord.pedido=tuplaEspecial["id"]
                  quiebrerecord.sku=tuplaEspecial["sku"].to_s
                  quiebrerecord.cantidad=diferenciaProductos
                  quiebrerecord.dineroperdido=diferenciaProductos*precio
                  quiebrerecord.save

                end


              end

            elsif(reservasmias>0)
              precio=PreciosTemporal.where(SKU:tuplaEspecial["sku"])
              direccion=Contact.queryDireccion(tuplaEspecial["direccion"])
              cantidadInteger=tuplaEspecial["cantidad"].to_i
              precioInteger=precio[0].precio
              stockController.mover_a_despacho_sku(tuplaEspecial["sku"],cantidadInteger)
              stockController.despachar_sku(tuplaEspecial["sku"],cantidadInteger,precioInteger,direccion,tuplaEspecial["id"])
              Reserva.updateutilizado(tuplaEspecial["sku"],tuplaEspecial["cantidad"].to_i,tuplaEspecial["rut"])


            else
              #Vamos a pedir la suma de las reservas junto con la cantidad pedida menos el stock disponible ya que esa es la demanda que hayq ue cumplir
              ApisHelper.pedirProducto(tuplaEspecial["sku"],tuplaEspecial["cantidad"].to_i+reservasotros-stockDisponible)
              precio=PreciosTemporal.where(SKU:tuplaEspecial["sku"])
              direccion=Contact.queryDireccion(tuplaEspecial["direccion"])
              cantidadInteger=tuplaEspecial["cantidad"].to_i
              precioInteger=precio[0].precio
              stockController.mover_a_despacho_sku(tuplaEspecial["sku"],cantidadInteger)
              stockController.despachar_sku(tuplaEspecial["sku"],cantidadInteger,precioInteger,direccion,tuplaEspecial["id"])

              end


          else
            p "No hya stock disponible, tengo que pedir!"
            #Primero tengo que despachar lo que puedo
            #Da lo mismo las reservas aca, si no tengo disponible para despachar las reservas pierden prioridas
            diferenciaPorEnviar=tuplaEspecial["cantidad"].to_i-stockDisponible.to_i
            ApisHelper.pedirProducto(tuplaEspecial["sku"],diferenciaPorEnviar)
            #ahora si es que tengo stock hago un envio

            if(stockDisponible>0)
              precio=PreciosTemporal.where(SKU:tuplaEspecial["sku"])
              direccion=Contact.queryDireccion(tuplaEspecial["direccion"])
              cantidadInteger=stockDisponible
              precioInteger=precio[0].precio
              stockController.mover_a_despacho_sku(tuplaEspecial["sku"],cantidadInteger)
              stockController.despachar_sku(tuplaEspecial["sku"],cantidadInteger,precioInteger,direccion,tuplaEspecial["id"])
            end
            sleep(1)
            #ya mande entonces si es que tenia algo disponible, ahora tengo que ver si es que me llego algo
            stockDisponible2=stockController.getcantidadtotal(tuplaEspecial["sku"]).to_i
            if(stockDisponible2>0)
              #me llegaron mas cosas por enviar!
              if(stockDisponible2>=diferenciaPorEnviar)
                precio=PreciosTemporal.where(SKU:tuplaEspecial["sku"])
                direccion=Contact.queryDireccion(tuplaEspecial["direccion"])
                cantidadInteger=diferenciaPorEnviar.to_i
                precioInteger=precio[0].precio
                stockController.mover_a_despacho_sku(tuplaEspecial["sku"],cantidadInteger)
                stockController.despachar_sku(tuplaEspecial["sku"],cantidadInteger,precioInteger,direccion,tuplaEspecial["id"])
                #Significa que me llego mas de lo que tenia que mandarle, quedo con mas stock y le mando

              else
                #no me llego todo lo que tenia, le mando lo que me llego nomas y quiebro
                diferenciaPorEnviar=diferenciaPorEnviar.to_i-stockDisponible2.to_i
                precio=PreciosTemporal.where(SKU:tuplaEspecial["sku"])
                direccion=Contact.queryDireccion(tuplaEspecial["direccion"])
                cantidadInteger=stockDisponible2.to_i
                precioInteger=precio[0].precio
                stockController.mover_a_despacho_sku(tuplaEspecial["sku"],cantidadInteger)
                stockController.despachar_sku(tuplaEspecial["sku"],cantidadInteger,precioInteger,direccion,tuplaEspecial["id"])
                #Y ahora hago el quiebre por lo que me falto por enviar
                quiebrerecord=Quiebre.new
                quiebrerecord.nombrecliente=Contact.query(tuplaEspecial["direccion"])
                quiebrerecord.fechaquiebre=Time.now
                quiebrerecord.pedido=tuplaEspecial["id"]
                quiebrerecord.sku=tuplaEspecial["sku"].to_s
                quiebrerecord.cantidad=diferenciaPorEnviar
                quiebrerecord.dineroperdido=diferenciaPorEnviar*precio
                quiebrerecord.save



              end


            end






          end



          executarenSql="UPDATE ftp_pedidos SET envio=Date('now') WHERE id="+tuplaEspecial["id"].to_s+" AND sku="+tuplaEspecial["sku"].to_s
          FtpPedido.connection.execute(executarenSql)


      end




    end

    def self.spreeIntegration

      #Tengo que actualizar los stocks en el spree

      stockEnSpree= Probando.get("http://integra3.ing.puc.cl/store/api/stock_locations/1/stock_items?token=c3e93df2a2f0344c5d210ce4ebda88684d360f109a90329a&per_page=20000")
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
      preciosSpree
      procesarPedidosSpree



    end
    def self.backOrderFalse
      #Tambien tengo que aprovechar de cambiar todo a CLP

      @todos=Spree::StockItem.all
      @todos.each do |producto|
        producto['backorderable']=false
        producto.save
      end

      @precios=Spree::Price.all
      @precios.each do |precio|
        precio['currency']="CLP"
        precio.save
      end

      @variantes=Spree::Variant.all
      @variantes.each do |varianteSpree|
        if(varianteSpree['sku'].include? '.')
          varianteSpree['sku']=varianteSpree['sku'].to_s[0..-3]
          varianteSpree.save
        end

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
      #http://integra3.ing.puc.cl/store/api/orders/R156162404/payments/5/capture?token=2d322b9538440950685ad9c4d0d35bec9f670c9b0c01d5c4&per_page=100000
      #Depsues usando el order number saco el shipment number http://integra3.ing.puc.cl/store/api/orders/R156162404?token=2d322b9538440950685ad9c4d0d35bec9f670c9b0c01d5c4&per_page=100000
      #por ultimo ship http://integra3.ing.puc.cl/store/api/orders/R156162404/shipments/H35327667308/ship?token=2d322b9538440950685ad9c4d0d35bec9f670c9b0c01d5c4&per_page=100000
      #primero en verdad hay que sacar todas las ordenes que esten en estado complete
      ordenes= HTTParty.get("http://integra3.ing.puc.cl/store/api/orders?token=c3e93df2a2f0344c5d210ce4ebda88684d360f109a90329a&per_page=20000")
      ordenes['orders'].each do |ordenRevisar|
        if(ordenRevisar['state'].to_s=="complete" && ordenRevisar['shipment_state'].to_s!="shipped")
          #la orden esta en estado completa, tengo que capturar primero

          #linkgetidpedidopayment
          linkpayment="http://integra3.ing.puc.cl/store/api/orders/"+ordenRevisar['number'].to_s+"/payments?token=c3e93df2a2f0344c5d210ce4ebda88684d360f109a90329a"
          idpayment=HTTParty.get(linkpayment)






          p idpayment
          iddelpago=idpayment['payments'][0]
          p iddelpago
          p "IMPRIME LA WEA"
          linkCapturar="http://integra3.ing.puc.cl/store/api/orders/"+ordenRevisar['number'].to_s+"/payments/"+iddelpago['id'].to_s+"/capture?token=c3e93df2a2f0344c5d210ce4ebda88684d360f109a90329a"
          p linkCapturar
          p ordenRevisar['number']
          respuestaCapture=HTTParty.put(linkCapturar)



          linkdireccion="http://integra3.ing.puc.cl/store/api/checkouts/"+ordenRevisar['number']+"?token=c3e93df2a2f0344c5d210ce4ebda88684d360f109a90329a"
          linkSKU="http://integra3.ing.puc.cl/store/api/orders/"+ordenRevisar['number'].to_s+"?token=c3e93df2a2f0344c5d210ce4ebda88684d360f109a90329a&per_page=100"
          itemes=HTTParty.get(linkSKU)
          direccionSapo=HTTParty.put(linkdireccion)
          stockController=StockManagementController.new

          idpedido=200000+Random.rand(1000000)
          p itemes;
          #Reviso todos los items y llamo a la basura de cox
          itemes['line_items'].each do |itemEnviar|
            cantidad=itemEnviar['quantity'].to_i
            sku=itemEnviar['variant']['sku'].to_s
            precioIndividiaulalala=itemEnviar['variant']['price'].to_i
            stockController.mover_a_despacho_sku(sku,cantidad)
            stockController.despachar_sku(sku,cantidad,precioIndividiaulalala,direccionSapo['ship_address']['address1'].to_s,idpedido)

          end
























          #Ahora que tengo capturado el metodo de pago, tengo que sacar el shipment number
          linkShipment="http://integra3.ing.puc.cl/store/api/orders/"+ordenRevisar['number'].to_s+"?token=c3e93df2a2f0344c5d210ce4ebda88684d360f109a90329a"
          respuestaLinkShipment=HTTParty.get(linkShipment)
          #Ahora puedo sacar el shipment number que me sirve para marcar una orden como enviada
          linkShip="http://integra3.ing.puc.cl/store/api/orders/"+ordenRevisar['number'].to_s+"/shipments/"+respuestaLinkShipment['shipments'][0]['number'].to_s+"/ship?token=c3e93df2a2f0344c5d210ce4ebda88684d360f109a90329a"
          shipmentNumber=HTTParty.put(linkShip)
          #Listo! Con esto tenemos que se envio el pedido, solo me falta integrarlo con la api de envio de stock y no habria problemas.
          #Agregar valor metiendo las transacciones en las mismas tablas que usamos pa los ftp pedidos



        end
      end

    end
    def self.mandarATwitter(mensaje)
      sleep(3)
      TuitterHelper.sendTweet(mensaje)
    end

    def self.preciosSpree
      #En este metodo tengo que ver las cosas que se obtienen de la cola y ver cual es el precio que efectivamente corresponde!
      #Hay una tabla llamada productosJson donde estan los precios por defecto, en caso de no haber promoción usamos esa tabla.
      #hacer un query que SELECT * FROM tablaKappes WHERE NOW < > ORDER BY TIME LIMIT 1; ELSE productos Json LISTO!
      #Si el precio de spree es Distinto al de la tabla kappes que encontre significa que se activo promocion, enviar twitter.



      time=(Time.now.to_f * 1000).to_i
      @tdas=PromocionesActivas.all


      @tdas.each do |promocionvencida|
        if(promocionvencida.fin.to_i<=time.to_i)
          #ESTA VENCIDA.
          #QUE HAGO
          linkActualizar="http://integra3.ing.puc.cl/store/api/products/"+promocionvencida.id.to_s+"?product[price]="+promocionvencida.original.to_s+"&token=c3e93df2a2f0344c5d210ce4ebda88684d360f109a90329a"
          Probando.put(linkActualizar)
          promocionvencida.delete



        end


      end
      link="http://integra3.ing.puc.cl/store/api/products?token=c3e93df2a2f0344c5d210ce4ebda88684d360f109a90329a&per_page=10000"
      jsonConPrecios=HTTParty.get(link)
      hola=time.to_s
      sql="SELECT * FROM messages WHERE inicio::decimal<"+hola+" AND fin::decimal>"+hola+" ORDER BY llegada ASC"
      records_array = Message.connection.execute(sql)
      begin
      records_array.each do |recordo|


        nombre,costoprecio,idproducto,slug=getPrecioForSku(jsonConPrecios,recordo['sku'].delete!('|'))

        Rails.logger.fatal "HPALAALALALA"
        Rails.logger.fatal idproducto
        Rails.logger.fatal costoprecio.to_s
        Rails.logger.fatal recordo['precio'].to_s

        Rails.logger.fatal costoprecio.to_i-recordo['precio'].to_i
        Rails.logger.fatal "ACABO DE IMPRIMIR WEAS"
        if(costoprecio.to_s!=recordo['precio'].to_s)
         #Los precios son distintos, actualizo el Spree y mando un Twitter.
          b=PromocionesActivas.new
          b.original=costoprecio.to_i
          b.nuevo=recordo['precio'].to_i
          b.fin=recordo['fin'].to_s
          b.sku=recordo['sku'].to_i
          Rails.logger.fatal "ENTRE AL IF"
          Rails.logger.fatal "ENTRE AL IF"

          tiempofinal=Time.at(recordo['fin'].to_i/1000)
          nombreproducto=nombre.to_s[0..21]
          tiempoenString= tiempofinal.strftime("%d/%m - %H:%M")
          b.save
          linkActualizar="http://integra3.ing.puc.cl/store/api/products/"+idproducto.to_s+"?product[price]="+b.nuevo.to_s+"&token=c3e93df2a2f0344c5d210ce4ebda88684d360f109a90329a"
          HTTParty.put(linkActualizar)
          mandarATwitter("#ofertagrupo3 "+nombreproducto.to_s+" a $"+b.nuevo.to_s+" válido hasta el: "+tiempoenString.to_s+" http://www.centralahorro.cl/store/products/"+slug.to_s);






        else
          #Los precios son iguales, no hago nada de nada.


        end


      end
      rescue => e
        Rails.logger.info "Error al nose que  #{e}"
      end








    end



    def self.getPrecioForSku(json,sku)
      #busco dentro del json el sku buscado
      p sku
      precio=0
      idproducto=0;
      nombre=""
      slug=""

      json['products'].each do |i|


        if(i['master']['sku']==sku)
          precio+=(i['price']).to_i
          idproducto+=(i['id']).to_i
          nombre+=i['master']['name'].to_s
          slug+=i['master']['slug'].to_s

        end


      end
      return nombre,precio,idproducto,slug


    end






  end




