class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :address
      t.string :number
      t.string :phone
      t.string :rut

      t.timestamps
    end
  end
end
