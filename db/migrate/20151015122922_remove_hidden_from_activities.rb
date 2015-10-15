class RemoveHiddenFromActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :hidden
  end
end
