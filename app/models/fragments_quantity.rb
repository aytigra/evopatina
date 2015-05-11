class FragmentsQuantity < ActiveRecord::Base
  belongs_to :activity
  belongs_to :week

  validates :activity, :week, presence: true
  validates_uniqueness_of :activity, scope: :week_id

  def self.find_or_create(activity, week)
    fragments_quantity = self.where(activity_id: activity.id, week_id: week.id).first rescue nil
    if !fragments_quantity
      fragments_quantity = self.create(activity_id: activity.id, week_id: week.id)
    end
    fragments_quantity
  end
end
