class AddColumnNameToProducts < ActiveRecord::Migration
  def change
    add_column :products, :costo_almacenamiento, :integer
  end
end
