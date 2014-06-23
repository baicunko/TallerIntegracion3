class Modifycolumnareserva < ActiveRecord::Migration
  def change
    change_column :reservas, :sku, 'integer USING CAST(sku AS integer)'
  end
end
