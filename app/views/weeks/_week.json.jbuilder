json.current_day do
  json.extract! day, :id, :date, :route_path, :prev_path, :next_path
  json.sectors sectors.map(&:id)
end

json.sectors do
  sectors.each do |sector|
    json.set! sector.id do
      json.extract! sector, :id, :name, :description, :icon, :color
      json.subsectors sector.subsectors.map(&:id)
    end
  end
end

json.subsectors do
  subsectors.each do |subsector|
    json.set! subsector.id do
      json.extract! subsector, :id, :sector_id, :name, :description
      json.activities subsector.activities.map(&:id)
    end
  end
end

json.activities do
  activities.each do |activity|
    json.set! activity.id do
      json.extract! activity, :id, :subsector_id, :name, :description, :count
    end
  end
end
