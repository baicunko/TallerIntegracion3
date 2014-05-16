class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :firstname
      t.string :lastname
      t.string :shipto
      t.string :phone
      t.string :contactid
      t.string :organization
      t.string :address

      t.timestamps
    end
  end
end
