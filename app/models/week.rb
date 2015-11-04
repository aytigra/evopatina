class Week < ActiveRecord::Base
  attr_accessor :lapa_sum, :progress_sum
  attr_reader :previous_weeks

  belongs_to :user
  has_many :sector_weeks, dependent: :destroy
  has_many :fragments, dependent: :destroy

  validates :user, presence: true
  validates_uniqueness_of :date, scope: :user_id

  after_create :copy_lapa_from_previous_week

  scope :by_date, -> { order(date: :desc) }
  scope :by_rev_date, -> { order(date: :asc) }

  def date=(date)
    self[:date] = date.beginning_of_week
  end

  def self.get_week(user, date)
    self.find_or_create_by(user: user, date: date)
  end

  def previous_weeks
    def self.previous_weeks
      @previous_weeks
    end

    @previous_weeks = self.class.where(user_id: user_id)
                          .where('date < ? and date >= ?', date, date - 7.week)
                          .by_date.limit(7).to_a

    #should create missing weeks and add them to returned array
    if @previous_weeks.count < 7
      rebuilt_previous_weeks = []
      previous_dates = @previous_weeks.map(&:date)
      (1..7).each do |i|
        if !previous_dates.include?(date - i.week)
          rebuilt_previous_weeks << self.class.create(user: user, date: date - i.week)
        else
          rebuilt_previous_weeks << @previous_weeks.shift
        end
      end
      @previous_weeks = rebuilt_previous_weeks
    end
    @previous_weeks
  end

  def lapa_unset?
    lapa.any? { |s, l|  l == 0 }
  end

  def ratio(sector_id)
    if lapa[sector_id] > 0 && progress[sector_id] > 0
      ((progress[sector_id] / lapa[sector_id]) * 100).to_i
    else
      0
    end
  end

  def recount_progress
    res = Sector.hash(Fragment.joins(activity: :subsector).where(week_id: id).group(:sector_id).sum(:count))
    self.progress = res
    self
  end

  private

    def copy_lapa_from_previous_week
      if previous_week = self.class.where(user: user).where('date < ?', date).by_date.limit(1).take
        sector_weeks = SectorWeek.where(week: previous_week)
        ActiveRecord::Base.transaction do
          sector_weeks.each do |sw|
            SectorWeek.create(sector_id: sw.sector_id, week: self, lapa: sw.lapa)
          end
        end
      end
    end
end
