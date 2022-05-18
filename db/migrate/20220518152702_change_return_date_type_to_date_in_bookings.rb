class ChangeReturnDateTypeToDateInBookings < ActiveRecord::Migration[6.1]
  def change
    change_column :bookings, :return_date, :date
  end
end
