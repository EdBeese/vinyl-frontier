class AddSenderToMessages < ActiveRecord::Migration[6.1]
  def change
    add_reference :messages, :sender, null: false, foreign_key: { to_table: 'user' }
  end
end
