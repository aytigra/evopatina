@sectors.each do |sector|
  json.set! sector.id do
    json.extract! sector, :id, :name, :description, :icon
  end
end