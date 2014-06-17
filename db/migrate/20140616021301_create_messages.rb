class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sku
      t.string :precio
      t.string :inicio
      t.string :fin
    end
  end
end
