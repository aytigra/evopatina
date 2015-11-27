class WeekDB < ActiveRecord::Base
  self.table_name = "weeks"
end

class ConvertWeekIds < ActiveRecord::Migration
  def up
    WeekDB.find_each do |week_db|
      new_id = Week.new(week_db.date).id
      SectorWeek.where(week_id: week_db.id).update_all(week_id: new_id)
      Fragment.where(week_id: week_db.id).update_all(week_id: new_id)
    end
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
