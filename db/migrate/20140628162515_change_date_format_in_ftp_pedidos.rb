class ChangeDateFormatInFtpPedidos < ActiveRecord::Migration
  def change
    change_column :ftp_pedidos, :id, 'integer USING CAST(id AS integer)'
  end
end
