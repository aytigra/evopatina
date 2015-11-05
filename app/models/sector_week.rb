class SectorWeek < ActiveRecord::Base
  belongs_to :sector
  belongs_to :week

  validates :sector, :week, presence: true

  def self.sector_weeks_by_sectors(sectors, weeks)
    raw = self.where(sector_id: sectors, week_id: weeks)

    result = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = {} } }
    raw.each do |sw|
      result[sw.sector_id][sw.week_id] = {lapa: sw.lapa, progress: sw.progress}
    end
    result
  end

  def self.recount_progress(sector, week)
    progress = Fragment.joins(activity: :subsector).where(week: week, subsectors: {sector_id: sector.id}).sum(:count)
    SectorWeek.find_or_initialize_by(sector: sector, week: week).update(progress: progress)
  end

end