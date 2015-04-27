class Activity < ActiveRecord::Base
  belongs_to :subsector

  validates :subsector, :name, presence: true

  def self.activities_by_sectors(user)
    raw = Activity.joins(:subsector).where(subsectors: {user_id: user.id}).order(:id, :subsector_id)
            .select('activities.*, subsectors.name as subs_name, subsectors.sector_id as sector_id')

    # raw structure - array of activities hashes with own model properties, 
    # subsectors model properties and sectors ids

    # return structure
    # for each sector array of subsectors,
    # each subsector - hash with own model properties and array of activities
    # each activity - hash with own model properties
    #
    # result = {
    #   1 => [
    #         {id: 1, name: subs_name_1, activities: [a1..an]}, 
    #         {id: n, name: subs_name_n, activities: [a1..an]}
    #        ],
    #   2 => [
    #         {id: 1, name: subs_name_1, activities: [a1..an]}, 
    #         {id: n, name: subs_name_n, activities: [a1..an]}
    #        ]
    # }
    
    result = {}
    subsectors_indexes = {}
    Sector.keys.each { |k| subsectors_indexes[k] = {}, result[k] = []}
    raw.each do |a|
      if subsectors_indexes[a.sector_id][a.subsector_id].present?
        subsector_index = subsectors_indexes[a.sector_id][a.subsector_id]
        result[a.sector_id][subsector_index][:activities] << a
      else
        result[a.sector_id] << {id: a.subsector_id, name: a.subs_name, activities: [a]}
        subsector_index = result[a.sector_id].size - 1
        subsectors_indexes[a.sector_id][a.subsector_id] = subsector_index
      end
    end
    result
  end
end
