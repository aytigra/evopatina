require "#{Rails.root}/db/seed_helpers.rb"

class CreateSectors < ActiveRecord::Migration
  def up
    create_table :sectors do |t|
      t.belongs_to :user, index: true, null: false
      t.string :name
      t.text :description
      t.string :icon
      t.integer :position

      t.timestamps null: false
    end

    add_foreign_key :sectors, :users

    create_table :sector_weeks do |t|
      t.belongs_to :sector, index: true, null: false
      t.belongs_to :week, index: true, null: false
      t.float :lapa, default: 0.0
      t.float :progress, default: 0.0

      t.timestamps null: false
    end

    users_with_weeks = User.joins(:weeks).group(:id)
    populate_users_with_default_sectors(users_with_weeks)
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
