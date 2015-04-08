class CreateSubsectors < ActiveRecord::Migration
  def change
    create_table :subsectors do |t|
      t.belongs_to :user, index: true, null: false
      t.integer :sector_id, index: true, null: false
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    add_foreign_key :subsectors, :users
  end
end
