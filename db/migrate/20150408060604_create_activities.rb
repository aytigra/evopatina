class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.belongs_to :subsector, index: true, null: false
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    add_foreign_key :activities, :subsectors
  end
end
