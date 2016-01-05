class Activity < ActiveRecord::Base
  belongs_to :subsector
  has_many :fragments, dependent: :destroy
  has_one :sector, through: :subsector

  include RankedModel
  ranks :row_order, column: :position, with_same: :subsector_id

  validates :subsector, :name, presence: true

  def self.with_fragments_count(subsectors, week)
    week_id = week.id.to_i.to_s
    fragments_join = 'LEFT JOIN fragments
                      ON fragments.activity_id = activities.id
                      AND fragments.week_id = ' + week_id
    joins(fragments_join)
      .where(subsector_id: subsectors.map(&:id))
      .select('activities.*, fragments.count as count')
      .order(:subsector_id, :position)
  end
end
