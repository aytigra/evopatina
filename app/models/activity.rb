class Activity < ActiveRecord::Base
  belongs_to :subsector
  acts_as_list scope: :subsector
  has_many :fragments, dependent: :destroy

  validates :subsector, :name, presence: true

  def self.activities_by_subsectors(user, week)
    week_id = week.id.to_i.to_s
    fragments_join = 'LEFT JOIN fragments 
                      ON fragments.activity_id = activities.id 
                      AND fragments.week_id = ' + week_id
    raw = self.joins(:subsector, fragments_join)
              .where(subsectors: {user_id: user.id})
              .order(position: :asc)
              .select('activities.*, subsectors.sector_id as sector_id, fragments.count as count')

    result = {}

    raw.each do |activity|
      result[activity.subsector_id] ||= {}
      result[activity.subsector_id][activity.id] = activity
    end

    result
  end
end
