class Fragment < ActiveRecord::Base
  belongs_to :activity

  scope :sector, ->(id) { joins(activity: :subsector).where(subsectors: { sector_id: id }) }

  validates :activity, :week_id, presence: true
  validates :activity, uniqueness: { scope: :week_id }

  def self.find_or_create(activity, week)
    where(activity: activity, week_id: week.id).first_or_create
  end

  def self.progress_for_days(days, sectors)
    raw = joins(activity: :subsector)
      .where(subsectors: { sector_id: sectors })
      .where(week_id: days)
      .group(:week_id, :sector_id)
      .sum(:count)
    result = Hash.new { |h, k| h[k] = {} }

    sectors.each do |sector|
      days.each do |day|
        result[sector][day] = raw[[day, sector]] || 0.0
      end
    end

    result
  end

  def self.sum_by_sectors_from(sectors, date = 0)
    joins(activity: :subsector)
      .where(subsectors: { sector_id: sectors })
      .where('week_id > ?', date)
      .group(:sector_id)
      .sum(:count)
  end

  def self.sum_by_activities_from(activities, date = 0)
    where(activity_id: activities)
      .where('week_id > ?', date)
      .group(:activity_id)
      .sum(:count)
  end
end
