class Subsector < ActiveRecord::Base
  belongs_to :user
  has_many :activities, dependent: :destroy

  validates :user, :sector_id, :name, presence: true
  validates :sector_id, inclusion: { in: Sector.keys, message: 'is wrong' }

  def self.subsectors_by_sectors(user)
    raw = self.where(user_id: user.id).order(created_at: :desc)

    result = {}

    raw.each do |subsector|
      result[subsector.sector_id] ||= {}
      result[subsector.sector_id][subsector.id] = subsector
    end

    result
  end
end
