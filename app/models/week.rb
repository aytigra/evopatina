class Week < ActiveRecord::Base
  attr_reader :previous_weeks

  validates :date, uniqueness: true
  validate :date_in_past_or_present

  scope :by_date, -> { order(date: :desc) }
  scope :by_rev_date, -> { order(date: :asc) }

  PREV_WEEKS_NUM = 9

  def date=(date)
    self[:date] = date.beginning_of_week
  end

  def self.get_week(date)
    self.find_or_create_by(date: date)
  end

  def previous_weeks
    def self.previous_weeks
      @previous_weeks
    end

    @previous_weeks = self.class.where('date < ? and date >= ?', date, date - PREV_WEEKS_NUM.week)
                          .by_date.limit(PREV_WEEKS_NUM).to_a

    #should create missing weeks and add them to returned array
    if @previous_weeks.count < PREV_WEEKS_NUM
      rebuilt_previous_weeks = []
      previous_dates = @previous_weeks.map(&:date)
      (1..PREV_WEEKS_NUM).each do |i|
        if !previous_dates.include?(date - i.week)
          rebuilt_previous_weeks << self.class.create(date: date - i.week)
        else
          rebuilt_previous_weeks << @previous_weeks.shift
        end
      end
      @previous_weeks = rebuilt_previous_weeks
    end
    @previous_weeks
  end

  def previous
    Week.where(date: date - 1.week).take
  end

  def current?
    date == Date.current.beginning_of_week
  end

  def to_param
    date.strftime '%d-%m-%Y'
  end

  def route_path
    "/#{self.model_name.route_key}/#{to_param}"
  end

  def prev_path
    Week.new(date: date - 1.week).route_path
  end

  def next_path
    Week.new(date: date + 1.week).route_path if date < Date.current.beginning_of_week
  end

  def begin_end_text
    I18n.l(date, format: :short) + ' - ' + I18n.l(date.end_of_week, format: :short)
  end

  def days
    result = []
    (0..6).each do |i|
      ddate = date + i.days
      status = case
      when ddate == Date.current
        'primary'
      when ddate < Date.current
        'info'
      else
        'success'
      end
      result << {date: ddate.day, name: I18n.l(ddate, format: '%a'), status: status}
    end
    result
  end

  private
    def date_in_past_or_present
      if date > Date.current.beginning_of_week
        errors.add(:date, "can't be in the future week")
      end
    end
end
