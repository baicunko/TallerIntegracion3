class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.integer :used_space
      t.integer :total_space
      t.boolean :reception
      t.boolean :dispatch
      t.boolean :lung

      t.timestamps
    end
  end
end
