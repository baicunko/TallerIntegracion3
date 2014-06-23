  class Reserva < ActiveRecord::Base
    #Fuente: http://gimite.net/doc/google-drive-ruby/
    require "rubygems"
    require "google_drive"
    require 'time'

    session = GoogleDrive.login("grupo3tallerintegracion@gmail.com", "grupo3taller")

    @ws = session.spreadsheet_by_key("0As9H3pQDLg79dHRlSU9STDF5aVEyUFFjZS13U0lJbVE").worksheets[0]

  # Dumps all cells.
    def self.consumir()
      i = 0
      #Acordarnos de conectaros a google spreadhseet y cambiarlo
      for row in @ws.rows
        if (i>3)
          i+=1
          if(row[4].to_datetime+7.day>Time.now)
            sk = row[0]
            client = row[1]
            cantida = row[2].to_i
            utilizad =  row[3].to_i
            fech= row[4].to_datetime
            responsabl = row[5]
            probando= Reserva.where(sku:sk,cliente:client,fecha:fech,fila:i)
            if(probando.count==0)
              res = Reserva.new( cliente: client, sku: sk, cantidad: cantida, responsable: responsabl, utilizado: utilizad, fecha: fech,fila:i)
              res.save
            end
          end


        else
          i+=1
        end
      end
    end

    def self.stockReservadoTodo(sku)
      sql = "select cantidad from reservas WHERE sku="+sku.to_s
      resultado = Reserva.connection.execute(sql)
      begin
        return resultado[0]["cantidad"]
      rescue
        return 0
      end

    end

    def self.stockReservado(sku,cantidad,rut)
      updateReservas=Reserva.all
      updateReservas.each do |j| #reviso todo
        if(j["fecha"]+7.day<Time.now) #Si es que la reserva esta vencida la cantidad es 0
          Reserva.delete(j)
        end
      end

      reservascliente=Reserva.where(sku:sku) #cuando estoy pidiendo una reserva por SKU
      if(reservascliente.count==0)

      end




        todaslasreservasmias=0
        todaslasreservasdeotros=0

        reservascliente.each do |j|
          if(j["cliente"]==rut)
            todaslasreservasmias+=j["cantidad"]-j["utilizado"]

          else
            todaslasreservasdeotros+=j["cantidad"]

          end

        end
        p " JOAAOAALALAL"
        p todaslasreservasdeotros
        return [todaslasreservasmias, todaslasreservasdeotros]



      end



    def self.updateutilizado (sku, cantidadutilizado, rut)
      reservascliente=Reserva.where(sku: sku, cliente: rut)
      reservascliente["utilizado"]+=cantidadutilizado

    end
  # Yet another way to do so.
    def self.exponer()
      p @ws.rows  #==> [["fuga", ""], ["foo", "bar]]
    end
    #R Reloads the worksheet to get changes by other clients.
    #@ws.reload()
  end
