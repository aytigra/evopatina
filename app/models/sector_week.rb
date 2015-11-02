class SectorWeek < ActiveRecord::Base
  belongs_to :sector
  belongs_to :week

  validates :sector, :week, presence: true

  def self.sector_weeks_by_sectors(sectors, weeks)
    raw = self.where(sector_id: sectors, week_id: weeks)

    result = {}
    raw.each do |sw|
      result[sw.sector_id] ||= {}
      result[sw.sector_id][sw.week_id] = {lapa: sw.lapa, progress: sw.progress}
    end
    result
  end

end