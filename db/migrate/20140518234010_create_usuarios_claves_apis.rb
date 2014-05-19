class CreateUsuariosClavesApis < ActiveRecord::Migration
  def change
    create_table :usuarios_claves_apis do |t|
      t.string :grupo
      t.string :password

      t.timestamps
    end
  end
end
