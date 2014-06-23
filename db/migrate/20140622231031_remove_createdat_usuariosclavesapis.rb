class RemoveCreatedatUsuariosclavesapis < ActiveRecord::Migration
  def change
  	remove_column :usuarios_claves_apis, :created_at
  	remove_column :usuarios_claves_apis, :updated_at
  end
end
