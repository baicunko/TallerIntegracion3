module LoadingHelper
  require 'CSV'
  require 'date'
  require 'net/sftp'
  def self.import
    file = File.open(File.join(Rails.root, 'Pricing.csv'), "r+")
    buffer = file.read
    file.rewind
    file.puts "id,sku,precio,fecha_actualizacion,fecha_vigencia,costo_producto,costo_traspaso,costo_almacenamiento"
    file.print buffer
    file.close

    #Open file

    file = File.join(Rails.root, 'Pricing.csv')
	  File.read(file)
    CSV.foreach("#{Rails.root}/Pricing.csv", headers: true) do |row|
      product_hash = row.to_hash # exclude the price field
      arregloFechas=product_hash["fecha_actualizacion"].split('/')
      fechaArreglada=arregloFechas[1]+"/"+arregloFechas[0]+"/"+arregloFechas[2]
      product_hash["fecha_actualizacion"]=fechaArreglada
      probando=product_hash["fecha_vigencia"].split('/')
      fechaSuperArreglada=probando[1]+"/"+probando[0]+"/"+probando[2]
      product_hash["fecha_vigencia"]=fechaSuperArreglada
      product = Product.where(id: product_hash["id"])

      if product.count == 1
        product.first.update_attributes(product_hash.except("price")) # exclude the price field.
      else
        Product.create!(product_hash)
      end # end if !product.nil?
    end # end CSV.foreach
  end # end self.import(file)


  def self.importProductosJson


    #Open file

    file = File.join(Rails.root, 'Productos.csv')
    File.read(file)
    CSV.foreach("#{Rails.root}/Productos.csv", headers: true) do |row|
      product_hash = row.to_hash # exclude the price field
      p product_hash
        ProductosJson.create!(product_hash)

    end # end CSV.foreach
  end # end self.import(file)



  def self.Kappes

  end





end