class CreateStockManagements < ActiveRecord::Migration
  def change
    create_table :stock_managements do |t|

      t.timestamps
    end
  end
end
