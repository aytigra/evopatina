class Subsector < ActiveRecord::Base
  belongs_to :sector
  has_many :activities, dependent: :destroy

  include RankedModel
  ranks :row_order,
    :column => :position,
    :with_same => :sector_id

  validates :sector, :name, presence: true

  def self.subsectors_by_sectors(user)
    raw = self.joins(:sector).where(sectors: {user_id: user.id})

    result = {}

    raw.each do |subsector|
      result[subsector.sector_id] ||= {}
      result[subsector.sector_id][subsector.id] = subsector
    end

    result
  end
end
