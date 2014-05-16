class AddUtilizadoToReservas < ActiveRecord::Migration
  def change
    add_column :reservas, :utilizado, :integer
  end
end
