class FragmentsQuantitiesCountToFloat < ActiveRecord::Migration
  def up
    change_column :fragments_quantities, :count, :float, default: 0.0
  end

  def down
    change_column :fragments_quantities, :count, :integer
  end
end
