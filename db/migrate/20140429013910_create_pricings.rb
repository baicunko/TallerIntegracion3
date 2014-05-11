class CreatePricings < ActiveRecord::Migration
  def change
    create_table :pricings do |t|
      t.int :id
      t.string :SKU
      t.string :Precio
      t.string :FechaActualizacion
      t.string :FechaVigencia
      t.string :CostoProducto
      t.string :CostoTraspaso
      t.string :CostoAlmacenaje

      t.timestamps
    end
  end
end
