class Fragment < ActiveRecord::Base
  belongs_to :activity

  scope :sector, ->(id) { joins(activity: :subsector).where(subsectors: { sector_id: id }) }

  validates :activity, :week_id, presence: true
  validates :activity, uniqueness: { scope: :week_id }

  def self.find_or_create(activity, week)
    where(activity: activity, week_id: week.id).first_or_create
  end

  def self.progress_for_days(days)
    joins(activity: :subsector).where(week_id: days.map(&:id)).group(:sector_id).sum(:count)
  end
end
