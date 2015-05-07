class Activity < ActiveRecord::Base
  belongs_to :subsector
  has_many :fragments, dependent: :destroy

  validates :subsector, :name, presence: true

  def self.activities_by_subsectors(user)
    raw = self.joins(:subsector).where(subsectors: {user_id: user.id}).order(created_at: :desc)

    result = {}

    raw.each do |activity|
      if result[activity.subsector_id].present?
        result[activity.subsector_id][activity.id] = activity
      else
        result[activity.subsector_id] = {activity.id => activity}
      end
    end

    result
  end
end
