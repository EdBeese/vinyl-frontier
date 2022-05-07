class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :record, null: false, foreign_key: true
      t.datetime :pick_up_date
      t.datetime :return_date

      t.timestamps
    end
  end
end
