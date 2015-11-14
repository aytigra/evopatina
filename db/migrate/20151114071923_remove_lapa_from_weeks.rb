class RemoveLapaFromWeeks < ActiveRecord::Migration
  def up
    remove_columns :weeks, :lapa, :progress
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
