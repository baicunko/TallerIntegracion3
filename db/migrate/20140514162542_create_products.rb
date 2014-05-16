class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :sku
      t.integer :precio
      t.datetime :fecha_actualizacion
      t.datetime :fecha_vigencia
      t.integer :costo_producto
      t.integer :costo_traspaso

      t.timestamps
    end
  end
end
