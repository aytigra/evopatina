class RemoveUserFromSubsectors < ActiveRecord::Migration
  def up
    remove_foreign_key :subsectors, :users
    remove_column :subsectors, :user_id
  end

  def down
    ActiveRecord::IrreversibleMigration
  end
end
