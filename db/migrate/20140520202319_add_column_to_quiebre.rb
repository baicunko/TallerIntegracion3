class AddColumnToQuiebre < ActiveRecord::Migration
  def change
    add_column :quiebres, :dineroperdido, :integer
  end
end
