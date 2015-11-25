json.name ''
json.children sectors do |sector|
  json.name sector.name
  json.icon sector.icon
  json.color sector.color
  json.children subsectors[sector.id] do |subsector|
    json.name subsector.name
    json.color sector.color
    json.children activities[subsector.id] do |activity|
      json.name activity.name
      json.color sector.color
    end
  end
end
