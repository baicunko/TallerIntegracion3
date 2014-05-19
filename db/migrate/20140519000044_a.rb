class A < ActiveRecord::Migration
  def change
  	remove_column :usuarios_claves_apis, :id
  end
end
