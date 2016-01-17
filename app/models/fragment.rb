class Fragment < ActiveRecord::Base
  belongs_to :activity

  scope :sector, ->(id) { joins(activity: :subsector).where(subsectors: { sector_id: id }) }

  validates :activity, :day_id, presence: true
  validates :activity, uniqueness: { scope: :day_id }

  def self.find_or_create(activity, day)
    where(activity: activity, day_id: day.id).first_or_create
  end

  def self.progress_for_days(days, sectors)
    raw = joins(activity: :subsector)
      .where(subsectors: { sector_id: sectors })
      .where(day_id: days)
      .group(:day_id, :sector_id)
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
      .where('day_id > ?', date)
      .group(:sector_id)
      .sum(:count)
  end

  def self.sum_by_activities_from(activities, date = 0)
    where(activity_id: activities)
      .where('day_id > ?', date)
      .group(:activity_id)
      .sum(:count)
  end
end
