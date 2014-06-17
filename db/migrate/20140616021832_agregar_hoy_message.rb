class AgregarHoyMessage < ActiveRecord::Migration
  def change
	add_column :messages, :llegada, :datetime
  end
end
