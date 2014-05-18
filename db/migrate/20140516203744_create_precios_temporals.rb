class CreatePreciosTemporals < ActiveRecord::Migration
  def change
    create_table :precios_temporals do |t|
      t.integer :SKU
      t.integer :precio

      t.timestamps
    end
  end
end
