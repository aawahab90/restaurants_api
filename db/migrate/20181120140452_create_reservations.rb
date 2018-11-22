class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.references  :guest, foreign_key: true, index: true
      t.references  :restaurant, foreign_key: true, index: true
      t.string :status, default: 'pending'
      t.datetime :start_time
      t.integer :covers
      t.text :note
      t.timestamps
    end
  end
end
