class Week
  attr_reader :id, :date

  PREV_WEEKS_NUM = 9
  ROUTE_KEY = 'weeks'

  def initialize(date)
    @date = date.beginning_of_week
    @id = @date.strftime('%Y%m%d').to_i
  end

  def self.find(id)
    new(Date.strptime(id.to_s, '%Y%m%d'))
  end

  def self.get_week(date)
    week = new(date)
    SectorWeek.copy_lapa_from_previous_week(week)
    week
  end

  def previous_weeks
    return @previous_weeks if @previous_weeks

    @previous_weeks = (1..PREV_WEEKS_NUM).map do |i|
      self.class.new(date - i.week)
    end
    @previous_weeks
  end

  def previous
    self.class.new(date - 1.week)
  end

  def current?
    date == Date.current.beginning_of_week
  end

  def to_param
    date.strftime '%d-%m-%Y'
  end

  def route_path
    "/#{ROUTE_KEY}/#{to_param}"
  end

  def prev_path
    Week.new(date - 1.week).route_path
  end

  def next_path
    Week.new(date + 1.week).route_path if date < Date.current.beginning_of_week
  end

  def begin_end_text
    I18n.l(date, format: :short) + ' - ' + I18n.l(date.end_of_week, format: :short)
  end

  def days
    (0..6).map do |i|
      ddate = date + i.days
      status = case
      when ddate == Date.current
        'primary'
      when ddate < Date.current
        'success'
      else
        'info'
      end
      { date: ddate.day, name: I18n.l(ddate, format: '%a'), status: status }
    end
  end
end
