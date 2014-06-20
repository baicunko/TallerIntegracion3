class CreateReposicions < ActiveRecord::Migration
  def change
    create_table :reposicions do |t|
      t.string :sku
      t.string :fecha
      t.string :almacenid

      t.timestamps
    end
  end
end
