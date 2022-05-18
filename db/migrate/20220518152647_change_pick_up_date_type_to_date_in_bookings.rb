class ChangePickUpDateTypeToDateInBookings < ActiveRecord::Migration[6.1]
  def change
    change_column :bookings, :pick_up_date, :date
  end
end
