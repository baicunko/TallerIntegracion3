class ChangeStringFormatInMyTable < ActiveRecord::Migration
  def change
  	change_column :products, :sku, 'integer USING CAST(sku AS integer)'
  end
end
