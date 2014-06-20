class CreatePruebanats < ActiveRecord::Migration
  def change
    create_table :pruebanats do |t|

      t.timestamps
    end
  end
end
