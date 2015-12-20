class Subsector < ActiveRecord::Base
  belongs_to :sector
  has_many :activities, dependent: :destroy

  include RankedModel
  ranks :row_order, column: :position, with_same: :sector_id

  validates :sector, :name, presence: true

  scope :where_sectors, -> (sectors) { where(sector: sectors.map(&:id)).order(:sector_id, :position) }
end
