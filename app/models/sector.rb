class Sector < ActiveRecord::Base
  default_scope { order(:position) }

  belongs_to :user
  has_many :subsectors, dependent: :destroy

  include RankedModel
  ranks :row_order, column: :position, with_same: :user_id

  validates :user, :name, presence: true
end
