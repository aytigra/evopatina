json.current_week do
  json.extract! week, :id, :date, :route_path, :prev_path, :next_path, :begin_end_text, :days
end

json.weeks do
  weeks.each do |w|
    json.set! w.id do
      json.extract! w, :id, :route_path
    end
  end
end

json.sectors do
  sectors.each do |sector|
    json.set! sector.id do
      json.extract! sector, :id, :name, :description, :icon, :color, :position
      json.subsectors subsectors_ids[sector.id]
      json.weeks do
        sector.weeks.each do |id, week|
          json.set! id do
            json.extract! week, :lapa, :progress, :lapa_sum, :progress_sum, :position
          end
        end
      end
    end
  end
end

json.subsectors do
  subsectors.each do |subsector|
    json.set! subsector.id do
      json.extract! subsector, :id, :sector_id, :name, :description, :position
      json.activities activities_ids[subsector.id]
    end
  end
end

json.activities do
  activities.each do |activity|
    json.set! activity.id do
      json.extract! activity, :id, :subsector_id, :name, :description, :count, :position
    end
  end
end