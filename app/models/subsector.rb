class Subsector < ActiveRecord::Base
  belongs_to :sector
  has_many :activities, dependent: :destroy

  include RankedModel
  ranks :row_order, column: :position, with_same: :sector_id

  validates :sector, :name, presence: true

  def self.subsectors_by_sectors(user)
    joins(:sector).where(sectors: { user_id: user.id }).group_by(&:sector_id)
  end
end
