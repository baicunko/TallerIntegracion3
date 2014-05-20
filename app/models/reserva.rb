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


      else
        i+=1
      end
    end
  end

  def self.stockReservado(sku)
    valor=0
    sql = Reserva.where(sku:sku)
    sql.each do |tuplas|
      if(tuplas["fecha"]+7.day>Time.now)
        valor+=tuplas["cantidad"]

      end
    end
    return valor


  end


# Yet another way to do so.
  def self.exponer()
    p @ws.rows  #==> [["fuga", ""], ["foo", "bar]]
  end
  #R Reloads the worksheet to get changes by other clients.
  #@ws.reload()
end
