class FtpPedido < ActiveRecord::Base
  require 'net/sftp'
  require 'nokogiri'

  include Mongo
  mongo_client = MongoClient.new
  db = mongo_client.db("pedidosftp")
  @coll = db.collection("pedidos")

  def self.verPedidos
    Net::SFTP.start('integra.ing.puc.cl', 'grupo3', :password => '23093md') do |sftp|
      files = sftp.dir.foreach('Pedidos') do |file|
        if file.name.split('.')[1]=="xml"
          sftp.file.open("Pedidos/"+file.name, "r") do |d|
            name = file.name
            name = name.delete! 'pedido_'
            name = name.delete! '.xml'
            nameInt = name.to_i
            nameNew = OptimizarFtp.where(id: nameInt)
            if nameNew.count == 0
              doc = Nokogiri::XML(d)

              actual = doc.xpath('//Pedidos')
              f = actual.at_xpath("@fecha").text
              h = actual.at_xpath("@hora").text
              d = actual.at_xpath("direccionId").text
              r = actual.at_xpath("rut").text
              e = actual.at_xpath("fecha").text
              pedidos = doc.xpath("//Pedido")
              pedidos.each do |data|
                s = data.at_xpath("sku").text
                c = data.at_xpath("cantidad").text
                FtpPedido.where(id: name, sku: s).first_or_create(fecha: f, hora: h, direccion: d, rut: r, entrega: e, sku: s, cantidad: c, id: name)
                begin
                  MongoLaLleva(name, s, f, h, d, r, e, c)
                rescue	=> e
                  Rails.logger.info "Error al pedir productos a bodegas externas. #{e}"
                end
                OptimizarFtp.where(id: name).first_or_create(id: name)
              end #end if name
            end # end pedidos.each
          end # end file open
        end #end if
      end #end foreach
    end #end sftp
  end #end metodo

  def self.MongoLaLleva(name, s, f, h, d, r, e, c)
    i = @coll.find(id: name, sku: s).to_a.count
    puts "Aca va el conteo"
    puts i
    if i == 0
      p "ACA INICIO NATA"
      doc = {"fecha" => f, "hora" => h, "direccion" => d, "rut" => r, "entrega" => e, "sku" => s, "cantidad" => c, "id" => name}
      p doc
      id = @coll.insert(doc)
      p id
      p "ACA FIN NATA"
    end
  end
end

