class Columnaftpenvio < ActiveRecord::Migration
  def change
  	add_column("ftp_pedidos", "envio", :datetime)
  end
end
