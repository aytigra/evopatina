class Subsector < ActiveRecord::Base
  belongs_to :user
  has_many :activities

  validates :user, :sector_id, :name, presence: true
  validates :sector_id, inclusion: { in: Sector.keys, message: 'is wrong' }

  def self.subsectors_by_sectors(user)
    raw = self.where(user_id: user.id).order(created_at: :desc)

    result = {}

    raw.each do |subsector|
      if result[subsector.sector_id].present?
        result[subsector.sector_id][subsector.id] = subsector
      else
        result[subsector.sector_id] = {subsector.id => subsector}
      end
    end

    result
  end
end
