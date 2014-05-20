class FtpPedido < ActiveRecord::Base
	require 'net/sftp'
	require 'nokogiri'

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
								OptimizarFtp.where(id: name).first_or_create(id: name)
							end #end if name
						end # end pedidos.each
					end # end file open
				end #end if
			end #end foreach
		end #end sftp
	end #end metodo
end

