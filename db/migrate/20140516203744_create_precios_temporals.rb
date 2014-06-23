class CreatePreciosTemporals < ActiveRecord::Migration
  def change
    create_table :precios_temporals do |t|
      t.integer :sku
      t.integer :precio

      t.timestamps
    end
  end
end
