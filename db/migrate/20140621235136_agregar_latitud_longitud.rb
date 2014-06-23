class AgregarLatitudLongitud < ActiveRecord::Migration
  def change
  	add_column :sent_items_pedidos, :latitude, :float
  	add_column :sent_items_pedidos, :longitude, :float
  end
end
