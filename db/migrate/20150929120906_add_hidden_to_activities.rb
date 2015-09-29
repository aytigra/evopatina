class AddHiddenToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :hidden, :boolean
  end
end
