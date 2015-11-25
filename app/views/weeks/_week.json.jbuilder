json.extract! week, :id, :date, :route_path, :prev_path, :next_path, :begin_end_text, :days

json.set! :sectors do
  sectors.each do |sector|
    json.set! sector.id do
      json.extract! sector, :id, :name, :description, :icon, :color, :position
      json.set! :weeks do
        sector.weeks.each do |id, week|
          json.set! id do
            json.extract! week, :lapa, :progress, :lapa_sum, :progress_sum, :position
          end
        end
      end

      json.set! :subsectors do
        subsectors[sector.id] ||= {}
        subsectors[sector.id].each do |subsector|
          json.set! subsector.id do
            json.extract! subsector, :id, :sector_id, :name, :description, :position

            json.set! :activities do
              activities[subsector.id] ||= {}
              activities[subsector.id].each do |activity|
                json.set! activity.id do
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