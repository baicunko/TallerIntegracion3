class FtpPedido < ActiveRecord::Base
	require 'net/sftp'
	require 'Nokogiri'

	def self.verPedidos
		#server = "http://integra.ing.puc.cl/"
		#user = "grupo3"
		#password = "23093md"

		Net::SFTP.start('integra.ing.puc.cl', 'grupo3', :password => '23093md') do |sftp|
		#ftp.login(user = "grupo3", password = "23093md")
		files = sftp.dir.foreach('Pedidos') do |file|
			if file.name.split('.')[1]=="xml"
			sftp.file.open("Pedidos/"+file.name, "r") do |d|
				name = file.name
				name = name.delete! 'pedido_'
				name = name.delete! '.xml'			
				if FtpPedido.where(id: name)==0


		#files = ftp.nlst('pedido_*')

		#Net::FTP.open('integra.ing.puc.cl') do |ftp|
			#ftp.login('grupo3', '23093md')
			#ftp.chdir('Pedidos')
			#files = ftp.nlst('*')

		#entry.name.split('.')[1]=="xml"

			#files.each do |file|
			#name = File.basename(file, ".xml")
			#name = name.delete! 'pedido_'
			#if name.to_i > @savedLastOrder
				#ftp.getbinaryfile(file)
				doc = Nokogiri::XML(d)

				actual = doc.xpath('//Pedidos')
				f = actual.at_xpath("@fecha").text
				h = actual.at_xpath("@hora").text
				d = actual.at_xpath("direccionId").text
				r = actual.at_xpath("rut").text
				e = actual.at_xpath("fecha").text	

				pedidos = doc.xpath("//Pedido")
				pedidos.each do |data|
					#p = FtpPedido.new
					#p.fecha = f		
					#puts p.fecha
					#p.hora = h
					#puts p.hora
					#p.direccion = d
					#puts p.direccion
					#p.rut = r
					#puts p.rut
					#p.entrega = e
					#puts p.entrega
					#p.sku 
					s = data.at_xpath("sku").text
					#puts p.sku
					#p.cantidad
					c = data.at_xpath("cantidad").text
					#puts p.cantidad
					#p.save
					FtpPedido.where(id: name, sku: s).first_or_create(fecha: f, hora: h, direccion: d, rut: r, entrega: e, sku: s, cantidad: c, id: name)

				end # end pedidos.each
			end # end file open
		end #end if
		end #end foreach
		end #end sftp
	end # end ftp
end #end class

