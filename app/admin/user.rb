ActiveAdmin.register User do
  permit_params :email
  actions :all, except: [:create]

  filter :email
  filter :locale
  filter :sign_in_count
  filter :current_sign_in_at
  filter :current_sign_in_ip
  filter :created_at

  index do
    id_column
    column :email
    column "Activities" do |user|
      Activity.joins(subsector: :sector).where(sectors: { user_id: user.id }).count
    end
    column "Progress" do |user|
      Fragment.joins(activity: { subsector: :sector }).where(sectors: { user_id: user.id }).sum(:count)
    end
    column "Last activity" do |user|
      Fragment.joins(activity: { subsector: :sector }).where(sectors: { user_id: user.id }).last.try(:created_at)
    end
    column :locale
    column :sign_in_count
    column :current_sign_in_at
    column :current_sign_in_ip
    column :created_at

    actions
  end
end
