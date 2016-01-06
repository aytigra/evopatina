class Sector < ActiveRecord::Base
  attr_accessor :weeks

  belongs_to :user
  has_many :subsectors, dependent: :destroy
  has_many :activities, through: :subsectors
  has_many :fragments, through: :activities

  include RankedModel
  ranks :row_order, column: :position, with_same: :user_id

  validates :user, :name, presence: true

  scope :load_tree_for, ->(user, day) do
    includes(:subsectors, :activities, :fragments)
     .where(user: user)
     .where(fragments: { week_id: [nil, day.id] })
     .order('sectors.position, subsectors.position, activities.position')
  end
end
