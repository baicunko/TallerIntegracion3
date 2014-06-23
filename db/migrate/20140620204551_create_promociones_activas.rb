class CreatePromocionesActivas < ActiveRecord::Migration
  def change
    create_table :promociones_activas do |t|
      t.integer :sku
      t.integer :original
      t.integer :nuevo
      t.string :fin

      t.timestamps
    end
  end
end
