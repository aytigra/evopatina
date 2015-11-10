class Sector < ActiveRecord::Base
  attr_accessor :weeks

  belongs_to :user
  has_many :subsectors, dependent: :destroy
  has_many :sector_weeks, dependent: :destroy

  include RankedModel
  ranks :row_order,
    :column => :position,
    :with_same => :user_id

  validates :user, :name, presence: true

  def self.sectors_with_weeks(user, weeks)
    sectors = self.where(user: user)
    sector_weeks = SectorWeek.sector_weeks_by_sectors(sectors, weeks)

    sectors.each do |sector|
      sector.weeks = Hash.new { |h,k| h[k] = {} }
      lapa_sum = 0.0
      progress_sum = 0.0

      (0..weeks.length-1).reverse_each do |i| #starting from the last week
        week_id = weeks[i].id
        #fill sector.weeks
        sector.weeks[week_id][:lapa] = sector_weeks[sector.id][week_id][:lapa] || 0.0
        sector.weeks[week_id][:progress] = sector_weeks[sector.id][week_id][:progress] || 0.0
        #find sums of lapas and progresses by last 4 weeks for each week
        lapa_sum += sector.weeks[week_id][:lapa]
        progress_sum += sector.weeks[week_id][:progress]

        if i+4 < weeks.length #if not out of weeks range
          week_out_id = weeks[i+4].id
          lapa_sum -= sector.weeks[week_out_id][:lapa]
          progress_sum -= sector.weeks[week_out_id][:progress]
        end

        sector.weeks[week_id][:lapa_sum] = lapa_sum
        sector.weeks[week_id][:progress_sum] = progress_sum
        sector.weeks[week_id][:position] = i
      end
    end

    sectors
  end


  def self.hash(values = {})
    res = {}
    values.each do |i|
      res[i] = values[i] || 0
    end
    res
  end

end