class Fragment < ActiveRecord::Base
  belongs_to :activity

  scope :sector, ->(id) { joins(activity: :subsector).where(subsectors: { sector_id: id }) }
  scope :user, ->(id) { where(activity: Activity.unscoped.user(id)) }

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

  def self.sum_by_days(days, user = nil)
    scope = Fragment.where(day_id: days.map(&:id))
    scope = scope.user(user.id) if user && user.is_a?(User)

    scope.group(:day_id).sum(:count)
  end

  def self.compact_old_fragments
    day101 = Day.new(Date.current - 101.days)
    old_fragments_counts = where('day_id < ?', day101.id).group(:activity_id).sum(:count)
    old_fragments_counts.each do |activity_id, sum|
      transaction do
        cumulative_fragment = where(activity_id: activity_id, day_id: day101.id).first_or_create
        cumulative_fragment.update_attribute(:count, sum)
        where(activity_id: activity_id).where('day_id < ?', day101.prev_day.id).delete_all
      end
    end
  end
end
