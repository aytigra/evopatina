class Week < ActiveRecord::Base
  attr_reader :previous_weeks

  validates :date, uniqueness: true
  validate :date_in_past_or_present

  after_create :copy_lapa_from_previous_week

  scope :by_date, -> { order(date: :desc) }
  scope :by_rev_date, -> { order(date: :asc) }

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

    @previous_weeks = self.class.where('date < ? and date >= ?', date, date - 7.week)
                          .by_date.limit(7).to_a

    #should create missing weeks and add them to returned array
    if @previous_weeks.count < 7
      rebuilt_previous_weeks = []
      previous_dates = @previous_weeks.map(&:date)
      (1..7).each do |i|
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

    def copy_lapa_from_previous_week
      if previous_week = self.class.where(date: date - 1.week).by_date.limit(1).take
        sector_weeks = SectorWeek.where(week: previous_week)
        ActiveRecord::Base.transaction do
          sector_weeks.each do |sw|
            SectorWeek.create(sector_id: sw.sector_id, week: self, lapa: sw.lapa)
          end
        end
      end
    end

    def date_in_past_or_present
      if date > Date.current.beginning_of_week
        errors.add(:date, "can't be in the future week")
      end
    end
end
