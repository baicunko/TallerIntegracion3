class ChangecolumnSpree < ActiveRecord::Migration
  def change
    change_column :spree_prices, :amount,  :decimal, :precision => 10, :scale => 2
    change_column :spree_line_items, :price,  :decimal, :precision => 10, :scale => 2
  end
end
