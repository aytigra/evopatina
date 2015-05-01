@activities.each do |sub_id, activities|
  json.set! sub_id do
    activities.each do |id, activity|
      json.set! id do
        json.extract! activity, :id, :subsector_id, :name, :description
      end
    end
  end
end
