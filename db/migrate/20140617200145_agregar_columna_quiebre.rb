class AgregarColumnaQuiebre < ActiveRecord::Migration
  def change
  	add_column :quiebres, :cantidad, :integer
  end
end
