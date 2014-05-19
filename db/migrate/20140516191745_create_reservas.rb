class CreateReservas < ActiveRecord::Migration
  def change
    create_table :reservas do |t|
      t.datetime :fecha
      t.string :cliente
      t.string :sku
      t.integer :cantidad
      t.string :responsable
      t.integer :utilizado


      t.timestamps
    end
    def change
   change_column :reservas, :sku, :integer
  end
  end
end
