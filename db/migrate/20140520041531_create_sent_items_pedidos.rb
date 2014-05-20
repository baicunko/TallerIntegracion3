class CreateSentItemsPedidos < ActiveRecord::Migration
  def change
    create_table :sent_items_pedidos do |t|
      t.integer :sku
      t.integer :cantidad
      t.integer :precio
      t.string :direccion
      t.integer :pedidoid
      t.boolean :respuesta

      t.timestamps
    end
  end
end
