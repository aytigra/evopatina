class Subsector < ActiveRecord::Base
  belongs_to :user
  has_many :activities

  validates :user, :sector_id, :name, presence: true
  validates :sector_id, inclusion: { in: Sector.keys, message: 'is wrong' }
end
