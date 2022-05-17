class SetAvailabilityDefault < ActiveRecord::Migration[6.1]
  def change
    change_column :records, :available, :boolean, default: true
  end
end
