class Message < ActiveRecord::Base
require 'bunny'
def self.GetMessageCant

		b = Bunny.new "amqp://jckkgxhc:l8S5CYdqKNlJGYRFWWKOaEJN4DcczTHU@tiger.cloudamqp.com/jckkgxhc"
		b.start # start a communication session with the amqp server

		q = b.queue("ofertas", :auto_delete => true) # declare a queue
		# p = b.queue("reposiciones")

		# declare default direct exchange which is bound to all queues
		e = b.exchange("")

		num_mensajes = q.message_count
		num_mensajes.times do 
			mensaje = q.pop[2] # get message from the queue
			mensaje = String.try_convert(mensaje)  #convertir el mensaje tipo nil a tipo string
			msg = mensaje.split(',')
			sku = (msg[0].split(':'))[1].strip 		#obtenemos los datos y les sacamos los espacios en blanco del principio y final
			sku.gsub! /"/, '|'			#le quitamos las comillas al sku
			precio = (msg[1].split(':'))[1].strip
			inicio = (msg[2].split(':'))[1].strip
			fin = ((msg[3].split(':'))[1].strip).delete! "}"
			Message.where(sku: sku, precio: precio, inicio: inicio, fin: fin).first_or_create(sku: sku, precio: precio, inicio: inicio, fin: fin, llegada: Time.now) #insertamos los datos en la tabla de ofertas
		end
		b.stop # close the connection
	end

	#codigo sin probar
	def self.GetMessage

		b = Bunny.new "amqp://jckkgxhc:l8S5CYdqKNlJGYRFWWKOaEJN4DcczTHU@tiger.cloudamqp.com/jckkgxhc"
		b.start # start a communication session with the amqp server

		q = b.queue("ofertas", :auto_delete => true) # declare a queue
		# p = b.queue("reposiciones")

		# declare default direct exchange which is bound to all queues
		e = b.exchange("")

		q.subscribe do |payload|
			mensaje = String.try_convert(payload)  #convertir el mensaje tipo nil a tipo string
			puts payload
			puts mensaje
			msg = mensaje.split(',')
			sku = (msg[0].split(':'))[1].strip 		#obtenemos los datos y les sacamos los espacios en blanco del principio y final
			sku.gsub! /"/, '|'			#le quitamos las comillas al sku
			precio = (msg[1].split(':'))[1].strip
			inicio = (msg[2].split(':'))[1].strip
			fin = ((msg[3].split(':'))[1].strip).delete! "}"
			Message.where(sku: sku, precio: precio, inicio: inicio, fin: fin).first_or_create(sku: sku, precio: precio, inicio: inicio, fin: fin, llegada: Time.now) #insertamos los datos en la tabla de ofertas
		end
		b.stop
	end

	#codigo que probe y dejo la cagaa
	def self.GetMessageRepo
		b = Bunny.new "amqp://jckkgxhc:l8S5CYdqKNlJGYRFWWKOaEJN4DcczTHU@tiger.cloudamqp.com/jckkgxhc"
		b.start # start a communication session with the amqp server

		q = b.queue("reposicion", :auto_delete => true) # declare a queue
		# p = b.queue("reposiciones")

		e = b.exchange("")

		q.subscribe do |payload|
			msg = String.try_convert(payload)  #convertir el mensaje tipo nil a tipo string
			msg = msg.split(',')
			sku = (msg[0].split(':'))[1].strip 		#obtenemos los datos y les sacamos los espacios en blanco del principio y final
			sku.gsub! /"/, '|'			#le quitamos las comillas al sku
			fecha = (msg[1].split(':'))[1].strip
			almacenid = (msg[2].split(':'))[1].strip.delete! "}"
			almacenid.gsub! /"/, '|'
			
			Reposicion.where(sku: sku, fecha: fecha, almacenid: almacenid).first_or_create(sku: sku, fecha: fecha, almacenid: almacenid) #insertamos los datos en la tabla de ofertas
		end
		b.stop
	end

	
end
