class Activity < ActiveRecord::Base
  belongs_to :subsector
  has_many :fragments, dependent: :destroy

  include RankedModel
  ranks :row_order, column: :position, with_same: :subsector_id

  validates :subsector, :name, presence: true

  def self.activities_by_subsectors(user, week)
    week_id = week.id.to_i.to_s
    fragments_join = 'LEFT JOIN fragments
                      ON fragments.activity_id = activities.id
                      AND fragments.week_id = ' + week_id
    joins(fragments_join, subsector: :sector)
      .where(sectors: { user_id: user.id })
      .select('activities.*, subsectors.sector_id as sector_id, fragments.count as count')
      .group_by(&:subsector_id)
  end
end
