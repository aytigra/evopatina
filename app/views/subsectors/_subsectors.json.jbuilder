@subsectors.each do |sub_id, subsectors|
  json.set! sub_id do
    subsectors.each do |id, subsector|
      json.set! id do
        json.extract! subsector, :id, :sector_id, :name, :description, :position
      end
    end
  end
end