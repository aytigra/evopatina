class RemoveUserFromWeeks < ActiveRecord::Migration
  def up
    dates = {}
    Week.all.each do |week|
      date_key = week.date.strftime '%Y%m%d'
      dates[date_key] ||= []
      dates[date_key] << week.id
    end

    weeks_to_delete = []
    dates.each do |date, weeks|
      if weeks.count > 1
        first_week_id = weeks.pop
        weeks.each do |week_id|
          SectorWeek.where(week_id: week_id).update_all(week_id: first_week_id)
          Fragment.where(week_id: week_id).update_all(week_id: first_week_id)
          weeks_to_delete << week_id
        end
      end
    end

    Week.delete_all(id: weeks_to_delete)

    remove_columns :weeks, :user_id
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
