json.array!(@subsectors) do |subsector|
  json.extract! subsector, :id, :user_id, :sector_id, :name, :description
  json.url subsector_url(subsector, format: :json)
end
