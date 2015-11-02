class Week < ActiveRecord::Base
  after_create :copy_lapa_from_previous_week

  belongs_to :user
  has_many :sector_weeks, dependent: :destroy
  has_many :fragments, dependent: :destroy

  attr_accessor :lapa_sum, :progress_sum, :previous_weeks

  store :progress
  store :lapa

  validates :user, presence: true
  validates_uniqueness_of :date, scope: :user_id

  scope :by_date, -> { order(date: :desc) }
  scope :by_rev_date, -> { order(date: :asc) }

  def date=(date)
    write_attribute(:date, date.beginning_of_week)
  end

  def self.get_week(user, date)
    week = self.find_or_create_by(user: user, date: date)
  end

  def previous_weeks
    if @previous_weeks
      @previous_weeks
    else
      @previous_weeks = Week.where(user_id: self.user_id)
                            .where('date < ? and date > ?', self.date, self.date - 8.week)
                            .by_date.limit(8)
    end
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
      if previous_week = Week.where(user: user, date: self.date - 1.week).take
        sector_weeks = SectorWeek.where(week: previous_week)
        sector_weeks.each do |sw|
          SectorWeek.create_with(lapa: sw.lapa).find_or_create_by(sector_id: sw.sector_id, week: self)
        end
      end
    end
end
