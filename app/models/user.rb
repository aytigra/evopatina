class User < ActiveRecord::Base
  has_many :sectors, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  protected

  def confirmation_required?
    false
  end
end
