class AddForeignKeyToSubsectors < ActiveRecord::Migration
  def change
    add_foreign_key :subsectors, :sectors
  end
end
