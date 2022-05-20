class AddBookingReferenceToMessages < ActiveRecord::Migration[6.1]
  def change
    add_reference :messages, :booking, null: false, foreign_key: true
  end
end
