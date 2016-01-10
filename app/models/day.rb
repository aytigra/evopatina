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

  def previous_days
    return @previous_days if @previous_days

    @previous_days = (1..PREV_DAYS_NUM).map do |i|
      self.class.new(date - i.day)
    end
    @previous_days
  end

  def previous
    self.class.new(date - 1.day)
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
    self.class.new(date - 1.day).route_path
  end

  def next_path
    self.class.new(date + 1.day).route_path if date < Date.current.beginning_of_day
  end
end
