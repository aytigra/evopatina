class Subsector < ActiveRecord::Base
  belongs_to :sector
  has_many :activities, dependent: :destroy

  include RankedModel
  ranks :row_order, column: :position, with_same: :sector_id

  validates :sector, :name, presence: true

  def self.by_sectors(subsectors)
    subsectors.each_with_object(Hash.new { |h, k| h[k] = [] }) { |s, h| h[s.sector_id] << s.id }
  end
end
