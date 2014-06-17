class ModTablaReposiciones < ActiveRecord::Migration
  def change
  	remove_column :reposicions, :id if column_exists?(:reposicions, :id)
  	remove_column :reposicions, :updated_at if column_exists?(:reposicions, :updated_at)
  	remove_column :reposicions, :created_at if column_exists?(:reposicions, :created_at)
  end
end
