class Activity < ActiveRecord::Base
  belongs_to :subsector

  validates :subsector, :name, presence: true

  def self.activities_by_sectors(user)
    raw = Activity.joins(:subsector).where(subsectors: {user_id: user.id}).order(:id, :subsector_id)
            .select('activities.*, subsectors.name as subs_name, subsectors.sector_id as sector_id')

    result = {}
    Sector.keys.each { |k| result[k] = {} }

    raw.each do |a|
      if result[a.sector_id][a.subsector_id].present?
        result[a.sector_id][a.subsector_id][:activities] << a
      else
        result[a.sector_id][a.subsector_id] = {name: a.subs_name, activities: [a]}
      end
    end

    result
  end
end
