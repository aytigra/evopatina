class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.text :lapa
      t.text :progress
      t.date :date

      t.references :user, index: true, null: false

      t.timestamps null: false
    end

    add_index :weeks, :date
  end
end
