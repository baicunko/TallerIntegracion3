class MessageRemoveColumnId < ActiveRecord::Migration
  def change
    remove_column :messages, :id if column_exists?(:messages, :id)
  end
end
