class Changetypeftp < ActiveRecord::Migration
  def change
  	#change_column :ftp_pedidos, :sku, 'integer USING CAST(sku AS integer)' migracion PostgreSQL

  	#remove_column :ftp_pedidos, :fecha
  	#add_column :ftp_pedidos, :fecha, :datetime
  	#remove_column :ftp_pedidos, :hora
  	#add_column :ftp_pedidos, :hora, :datetime
  	#remove_column :ftp_pedidos, :entrega
  	#add_column :ftp_pedidos, :entrega, :datetime
  	#add_column :ftp_pedidos, :id, :string


    change_column :ftp_pedidos, :sku, :integer
    change_column :ftp_pedidos, :fecha, :datetime
    change_column :ftp_pedidos, :hora, :datetime
    change_column :ftp_pedidos, :entrega, :datetime
    add_column("ftp_pedidos","id",:string)
  end
end
