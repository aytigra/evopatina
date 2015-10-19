module WeeksHelper
  def week_begin_end_text(week)
    I18n.l(week.date, format: :short) + ' - ' + I18n.l(week.date.end_of_week, format: :short)
  end

  def week_ratio_text(week, sector_id)
    number_to_human(week.progress[sector_id]) + '/' + number_to_human(week.lapa[sector_id])
  end

  def week_status_icon(week, sector_id)
    ratio = 0
    if week.lapa_sum[sector_id] > 0 && week.progress_sum[sector_id] > 0
      ratio = week.progress_sum[sector_id] / week.lapa_sum[sector_id]
    end

    case ratio
    when 1
      'heart'
    when 0
      'arrow-down'
    when 0.75..1
      'arrow-up'
    when 0.5..0.75
      'triangle-top'
    when 0.25..0.5
      'minus'
    when 0..0.25
      'triangle-bottom'
    else
      'heart'
    end
  end

end
