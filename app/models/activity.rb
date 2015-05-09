class Activity < ActiveRecord::Base
  belongs_to :subsector
  has_many :fragments_quantities, dependent: :destroy

  validates :subsector, :name, presence: true

  def self.activities_by_subsectors(user, week)
    week_id = week.id.to_i.to_s
    fragments_join = 'LEFT JOIN fragments_quantities 
                      ON fragments_quantities.activity_id = activities.id 
                      AND fragments_quantities.week_id = ' + week_id
    raw = self.joins(:subsector, fragments_join)
              .where(subsectors: {user_id: user.id})
              .order(created_at: :desc)
              .select('activities.*, subsectors.sector_id as sector_id, fragments_quantities.count as count')

    result = {}

    raw.each do |activity|
      result[activity.subsector_id] ||= {}
      result[activity.subsector_id][activity.id] = activity
    end

    result
  end
end
