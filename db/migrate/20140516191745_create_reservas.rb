class CreateReservas < ActiveRecord::Migration
  def change
    create_table :reservas do |t|
      t.datetime :fecha
      t.string :cliente
      t.string :sku
      t.integer :cantidad
      t.string :responsable

      t.timestamps
    end
  end
end
