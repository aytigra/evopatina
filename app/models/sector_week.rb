class SectorWeek < ActiveRecord::Base
  belongs_to :sector
  belongs_to :week

  validates :sector, :week, presence: true
end