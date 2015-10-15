json.extract! week, :id, :date, :progress, :lapa

json.set! :sectors do
  sectors.each do |sector|
    json.set! sector.id do
      json.extract! sector, :id, :name, :description, :icon
      json.lapa week.lapa[sector.id]
      json.progress week.progress[sector.id]

      json.set! :subsectors do
        subsectors[sector.id] ||= {}
        subsectors[sector.id].each do |id, subsector|
          json.set! id do
            json.extract! subsector, :id, :sector_id, :name, :description

            json.set! :activities do
              activities[subsector.id] ||= {}
              activities[subsector.id].each do |id, activity|
                json.set! id do
                  json.extract! activity, :id, :subsector_id, :sector_id, :name, :description, :count, :position
                end
              end
            end

          end
        end
      end
    end
  end
end