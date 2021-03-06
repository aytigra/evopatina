class Day
  attr_reader :id, :date

  PREV_DAYS_NUM = 9
  ROUTE_KEY = 'days'

  def initialize(date)
    @date = date.beginning_of_day
    @id = @date.strftime('%Y%m%d').to_i
  end

  def self.find(id)
    new(Date.strptime(id.to_s, '%Y%m%d'))
  end

  def previous_days(days_num = nil)
    days_num ||= PREV_DAYS_NUM

    return @previous_days if @previous_days

    @previous_days = (1..days_num).map do |i|
      self.class.new(date - i.day)
    end
    @previous_days
  end

  def prev_day
    self.class.new(date - 1.day)
  end

  def next_day
    self.class.new(date + 1.day) if date < Date.current.beginning_of_day
  end

  def current?
    date == Date.current.beginning_of_week
  end

  def text
    I18n.l(date, format: '%d %b %Y')
  end

  def text_short
    I18n.l(date, format: '%d %b')
  end

  def to_param
    date.strftime '%d-%m-%Y'
  end

  def route_path
    "/#{ROUTE_KEY}/#{to_param}"
  end

  def prev_path
    prev_day.route_path
  end

  def next_path
    next_day.route_path if next_day
  end
end
