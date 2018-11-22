class CreateGuests < ActiveRecord::Migration[5.2]
  def change
    create_table :guests do |t|
      t.references  :restaurant, foreign_key: true, index: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.timestamps
    end
    add_index :guests, :first_name
    add_index :guests, :last_name
  end
end
