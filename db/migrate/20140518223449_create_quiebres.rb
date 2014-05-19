class CreateQuiebres < ActiveRecord::Migration
  def change
    create_table :quiebres do |t|
      t.integer :pedido
      t.string :nombrecliente
      t.datetime :fechaquiebre

      t.timestamps
    end
  end
end
