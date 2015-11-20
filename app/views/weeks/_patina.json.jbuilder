json.name ''
json.children sectors do |sector|
  json.name sector.name
  json.icon sector.icon
  json.children subsectors[sector.id] do |subsector|
    json.name subsector.name
    json.children  activities[subsector.id] do |activity|
      json.name activity.name
    end
  end
end