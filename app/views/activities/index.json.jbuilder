json.array!(@activities) do |activity|
  json.extract! activity, :id, :subsector_id, :name, :description
  json.url activity_url(activity, format: :json)
end
