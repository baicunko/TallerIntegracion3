class CreateFtpPedidos < ActiveRecord::Migration
  def change
    create_table :ftp_pedidos, :id => false do |t|
	  t.string "fecha"
      t.string "hora"
      t.string "direccion"
      t.string "rut", :limit => 12
      t.string "entrega"
      t.string "sku"
      t.string "cantidad"
      #self.primary_key = "fecha pedido", "rut"
    end
  end
end
