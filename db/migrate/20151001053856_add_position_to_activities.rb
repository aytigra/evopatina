class AddPositionToActivities < ActiveRecord::Migration
  def up
    add_column :activities, :position, :integer

    Activity.update_all("position = id")
  end

  def down
    remove_column :activities, :position
  end
end
