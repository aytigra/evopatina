class RenameFragmentsWeekToDay < ActiveRecord::Migration
  def change
    rename_column :fragments, :week_id, :day_id
  end
end
