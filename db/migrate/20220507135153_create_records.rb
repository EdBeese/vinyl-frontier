class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.string :title
      t.string :artist
      t.string :genre
      t.integer :year
      t.boolean :available
      t.references :user, null: false, foreign_key: true
      t.integer :price

      t.timestamps
    end
  end
end
