class Sector < ActiveRecord::Base
  attr_accessor :weeks

  belongs_to :user
  has_many :subsectors, dependent: :destroy
  has_many :sector_weeks, dependent: :destroy

  include RankedModel
  ranks :row_order, column: :position, with_same: :user_id

  validates :user, :name, presence: true

  def self.sectors_with_weeks(user, weeks)
    sectors = where(user: user).order(:position).load
    sector_weeks = SectorWeek.sector_weeks_by_sectors(sectors, weeks)

    sectors.each do |sector|
      sector.fill_weeks(weeks.map(&:id), sector_weeks[sector.id])
    end

    sectors
  end

  def fill_weeks(weeks_ids, weeks_data)
    self.weeks = {}
    lapa_sum = progress_sum = 0.0
    length = weeks_ids.length
    is_tail = true
    # find sums of lapas and progresses by last 4 weeks for each week
    (0..length - 1).reverse_each do |pos| # starting from the last week
      week_id = weeks_ids[pos]
      lapa = weeks_data[week_id][:lapa] || 0.0
      progress = weeks_data[week_id][:progress] || 0.0
      # drop emty tail
      if is_tail && length > 1 && lapa == 0.0 && progress == 0.0
        length -= 1
        next
      else
        is_tail = false
      end

      lapa_sum += lapa
      progress_sum += progress
      if pos + 4 < length # if not out of weeks range
        lapa_sum -= weeks[weeks_ids[pos + 4]][:lapa]
        progress_sum -= weeks[weeks_ids[pos + 4]][:progress]
      end
      self.weeks[week_id] = { lapa: lapa, progress: progress, lapa_sum: lapa_sum,
        progress_sum: progress_sum, position: pos }
    end
  end
end
