class Users::RegistrationsController < Devise::RegistrationsController
  after_action :create_default_sectors, only: :create

  def confirm
  end

  #The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(_resource)
    confirm_path
  end

  def create_default_sectors
    return unless @user.persisted?
    require "#{Rails.root}/db/seed_helpers.rb"
    create_default_sectors_for_user(@user)
  end
end
