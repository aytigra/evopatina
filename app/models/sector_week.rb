class SectorWeek < ActiveRecord::Base
  belongs_to :sector

  validates :sector, :week_id, presence: true

  def self.sector_weeks_by_sectors(sectors, weeks)
    raw = where(sector_id: sectors.map(&:id), week_id: weeks.map(&:id))

    result = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = {} } }
    raw.each do |sw|
      result[sw.sector_id][sw.week_id] = { lapa: sw.lapa, progress: sw.progress }
    end
    result
  end

  def self.recount_sector(sector)
    return unless sector
    weeks = Fragment.sector(sector.id).group(:week_id).sum(:count)
    ActiveRecord::Base.transaction do
      weeks.each do |week_id, progress|
        find_or_initialize_by(sector_id: sector, week_id: week_id).update(progress: progress)
      end
    end
  end

  def self.recount_sector_week(sector_id, week_id)
    progress = Fragment.sector(sector_id).where(week_id: week_id).sum(:count)
    find_or_initialize_by(sector_id: sector_id, week_id: week_id).update(progress: progress)
  end

  #copy lapa when new week started
  def self.copy_lapa_from_previous_week(week)
    return unless week.current? && where(week_id: week.id).count == 0
    ActiveRecord::Base.transaction do
      where(week_id: week.previous.id).find_each do |sw|
        create(sector_id: sw.sector_id, week_id: week.id, lapa: sw.lapa)
      end
    end
  end
end
