class CreatePruebaDevelopments < ActiveRecord::Migration
  def change
    create_table :prueba_developments do |t|

      t.timestamps
    end
  end
end
