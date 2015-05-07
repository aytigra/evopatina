class Week < ActiveRecord::Base
  belongs_to :user

  store :progress
  store :lapa

  validates :user, presence: true
  validates_uniqueness_of :date, scope: :user_id

  scope :by_date, -> { order(date: :desc) }

  def date=(date)
    write_attribute(:date, date.beginning_of_week)
  end

  def self.last_week(user)
    week = self.where(user: user).by_date.limit(1).first rescue nil
    if week == nil || week.date != Date.today.at_beginning_of_week
      lapa = week == nil ? Sector.hash : week.lapa
      week = self.create(date: Date.today, lapa: lapa, progress: Sector.hash, user: user)
    end
    week
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

end
