class AddColumnToReserva < ActiveRecord::Migration
  def change
    add_column :reservas, :fila, :integer
  end
end
