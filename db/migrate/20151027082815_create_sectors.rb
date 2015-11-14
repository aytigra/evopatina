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

    User.joins(:weeks).group(:id).each do |user|
      weeks = Week.where(user_id: user.id)
      create_default_sectors_for_user(user).each do |old_id, sector|
        #relate subsectors to new sectors
        Subsector.where(user_id: user.id, sector_id: old_id).update_all(sector_id: sector.id)

        #fill new sector weeks relation with data from week hashes(lapa, progress)
        ActiveRecord::Base.transaction do
          weeks.each do |week|
            SectorWeek.new do |sw|
              sw.sector    = sector
              sw.week      = week
              sw.lapa      = week.lapa[old_id] || 0.0
              sw.progress  = week.progress[old_id] || 0.0
              sw.save
            end
          end
        end
      end
    end
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
