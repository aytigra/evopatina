class CreateFragmentsQuantities < ActiveRecord::Migration
  def change
    create_table :fragments_quantities do |t|
      t.belongs_to :week, index: true, null: false
      t.belongs_to :activity, index: true, null: false
      t.integer :count

      t.timestamps null: false
    end
  end
end
