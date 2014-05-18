class CreateStockInStores < ActiveRecord::Migration
  def change
    create_table :stock_in_stores do |t|
      t.integer :sku
      t.string :store_id
      t.integer :stock

      t.timestamps
    end
  end
end
