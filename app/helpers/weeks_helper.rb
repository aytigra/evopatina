module WeeksHelper
  def week_begin_end_text(week)
    I18n.l(week.date, format: :short) + ' - ' + I18n.l(week.date.end_of_week, format: :short)
  end

  def week_ratio_text(week, sector_id)
    number_to_human(week.progress[sector_id]) + '/' + number_to_human(week.lapa[sector_id])
  end
end
