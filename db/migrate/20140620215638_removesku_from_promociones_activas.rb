class RemoveskuFromPromocionesActivas < ActiveRecord::Migration
  def change
    remove_column :promociones_activas, :sku
    add_column :promociones_activas, :sku, :string
  end
end
