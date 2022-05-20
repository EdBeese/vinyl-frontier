class RemoveBookingReferenceToMessages < ActiveRecord::Migration[6.1]
  def change
    remove_column(:messages, :user, index: true, foreign_key: true)
  end
end
