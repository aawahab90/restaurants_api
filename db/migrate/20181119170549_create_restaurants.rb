class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
    	t.string :name
    	t.string :phone
    	t.string :email
    	t.string :location
    	t.string :opening_hour
    	t.string :closing_hour
    	t.integer :created_by_id
      t.boolean :archive, default: false
      t.timestamps
    end
    add_index :restaurants, :name
    add_index :restaurants, :location
  end
end
