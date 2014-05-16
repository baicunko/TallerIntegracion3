class CreateProductosJsons < ActiveRecord::Migration
  def change
    create_table :productos_jsons do |t|
      t.string :SKU
      t.string :Marca
      t.string :Modelo
      t.integer :PrecioNormal
      t.integer :PrecioInternet
      t.string :Descripcion
      t.string :Imagen
      t.string :Categoria1
      t.string :Categoria2
      t.string :Categoria3
      t.string :Categoria4
      t.string :Categoria5
      t.string :Categoria6
      t.string :Categoria7
      t.string :Categoria8

      t.timestamps
    end
  end
end
