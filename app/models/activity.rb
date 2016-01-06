class Activity < ActiveRecord::Base
  default_scope { order(:position) }

  belongs_to :subsector
  has_many :fragments, dependent: :destroy
  has_one :sector, through: :subsector

  include RankedModel
  ranks :row_order, column: :position, with_same: :subsector_id

  validates :subsector, :name, presence: true

  def count
    fragment = fragments.first
    fragment.present? ? fragment.count : 0.0
  end
end
