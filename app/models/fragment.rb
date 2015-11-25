class Fragment < ActiveRecord::Base
  belongs_to :activity
  belongs_to :week

  validates :activity, :week, presence: true
  validates :activity, uniqueness: { scope: :week_id }

  def self.find_or_create(activity, week)
    where(activity: activity, week: week).first_or_create
  end
end
