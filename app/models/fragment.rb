class Fragment < ActiveRecord::Base
  belongs_to :activity
  belongs_to :week

  validates :activity, :week, presence: true
  validates_uniqueness_of :activity, scope: :week_id

  def self.find_or_create(activity, week)
    fragment = self.where(activity: activity, week: week).first
    rescue ActiveRecord::RecordNotFound
      fragment = self.create(activity: activity, week: week)
    fragment
  end
end
