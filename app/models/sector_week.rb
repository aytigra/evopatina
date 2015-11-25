class SectorWeek < ActiveRecord::Base
  belongs_to :sector
  belongs_to :week

  validates :sector, :week, presence: true

  def self.sector_weeks_by_sectors(sectors, weeks)
    raw = where(sector_id: sectors, week_id: weeks)

    result = Hash.new { |h, k| h[k] = Hash.new { |hh, kk| hh[kk] = {} } }
    raw.each do |sw|
      result[sw.sector_id][sw.week_id] = { lapa: sw.lapa, progress: sw.progress }
    end
    result
  end

  def self.recount_progress(week)
    copy_lapa_from_previous_week(week)
    sectors = Fragment.joins(activity: :subsector).where(week: week).group(:sector_id).sum(:count)
    ActiveRecord::Base.transaction do
      sectors.each do |sector, progress|
        SectorWeek.find_or_initialize_by(sector_id: sector, week: week).update(progress: progress)
      end
    end
  end

  private

  #copy lapa when new week started
  def self.copy_lapa_from_previous_week(week)
    if week.current? && SectorWeek.where(week_id: week.id).count == 0
      ActiveRecord::Base.transaction do
        SectorWeek.where(week_id: week.previous.id).each do |sw|
          SectorWeek.create(sector_id: sw.sector_id, week: week, lapa: sw.lapa)
        end
      end
    end
  end

end