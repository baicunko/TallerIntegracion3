class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :sku
      t.integer :store_id
      t.float :costs

      t.timestamps
    end
  end
end
