module WeeksHelper
  def week_begin_end_text(week)
    week.date.to_s(:date) + ' - ' + week.date.end_of_week.to_s(:date)
  end

  def week_ratio_text(week, sector_id)
    number_to_human(week.progress[sector_id]) + '/' + number_to_human(week.lapa[sector_id])
  end
end
