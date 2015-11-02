class Sector < ActiveRecord::Base
  belongs_to :user
  has_many :subsectors, dependent: :destroy
  has_many :sector_weeks, dependent: :destroy

  include RankedModel
  ranks :row_order,
    :column => :position,
    :with_same => :user_id

  validates :user, :name, presence: true

  def self.hash(values = {})
    res = {}
    values.each do |i|
      res[i] = values[i] || 0
    end
    res
  end

end