class AddColumnsToRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :records, :tracks, :text
    add_column :records, :about, :text, default: ""
  end
end
