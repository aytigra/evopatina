json.name 'PATINA'
json.children sectors do |sector|
  json.name sector.name
  json.children subsectors[sector.id] do |subsector|
    json.name subsector.name
    json.children  activities[subsector.id] do |activity|
      json.name activity.name
    end
  end
end