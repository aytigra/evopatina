class RenameFragmentsQuantityToFragment < ActiveRecord::Migration
  def change
    rename_table :fragments_quantities, :fragments
  end
end
