class Activity < ActiveRecord::Base
  default_scope { order(:position) }

  belongs_to :subsector
  has_many :fragments, dependent: :destroy
  has_one :sector, through: :subsector

  include RankedModel
  ranks :row_order, column: :position, with_same: :subsector_id

  validates :subsector, :name, presence: true

  scope :counts_for, ->(day) do
    a = arel_table
    f = Fragment.arel_table
    join = a.outer_join(f).on(f[:activity_id].eq(a[:id]).and(f[:day_id].eq(day.id)))
    joins(join.join_sources).select(a[Arel.star], f[:count].as('count'))
  end

  def count
    self[:count] || 0.0
  end
end
