class Fragment < ActiveRecord::Base
  belongs_to :activity
  belongs_to :week

  validates :activity, :week, presence: true
  validates_uniqueness_of :activity, scope: :week_id
end
