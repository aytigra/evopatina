class Subsector < ActiveRecord::Base
  default_scope { order(:position) }

  belongs_to :sector
  has_many :activities, dependent: :destroy

  include RankedModel
  ranks :row_order, column: :position, with_same: :sector_id

  validates :sector, :name, presence: true
end
