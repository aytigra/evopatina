class AddPositionToSubsectors < ActiveRecord::Migration
  def up
    add_column :subsectors, :position, :integer

    Subsector.update_all("position = id")
  end

  def down
    remove_column :activities, :position
  end
end
