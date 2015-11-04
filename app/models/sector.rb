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
      sector.weeks = sector_weeks[sector.id]
      sector.weeks.each do |week|
        week[1][:lapa_sum] = 0
        week[1][:progress_sum] = 0
      end
    end

    # find sums of lapas and progresses by last 4 weeks
    # starting from last week
    # lapa_sum = {}
    # progress_sum = {}
    # (0..@weeks.length-1).reverse_each do |i|
    #   @sectors.each do |sector|
    #     lapa_sum[sector.id] ||= 0
    #     progress_sum[sector.id] ||= 0
    #     lapa_sum[sector.id] += @sector_weeks[sector.id][@weeks[i].id][:lapa]
    #     progress_sum[sector.id] += @sector_weeks[sector.id][@weeks[i].id][:progress]
    #     if i+4 < @weeks.length #if not out of range
    #       lapa_sum[sector.id] -= @sector_weeks[sector.id][@weeks[i+4].id][:lapa]
    #       progress_sum[sector.id] -= @sector_weeks[sector.id][@weeks[i+4].id][:progress]
    #     end
    #   end
    #   @weeks[i].lapa_sum = lapa_sum.clone
    #   @weeks[i].progress_sum = progress_sum.clone
    #   #hmm
    #   if @weeks[i].id == @current_week.id
    #     @current_week = @weeks[i]
    #   end
    # end
    #debug

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