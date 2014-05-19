class AddUtilizadoToReservas < ActiveRecord::Migration
  def change
    change_column :reservas, :utilizado, :integer
  end
end
