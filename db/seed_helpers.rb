def create_default_sectors_for_user(user)
  default_sectors = {
    1 => 'compressed',
    2 => 'education',
    3 => 'fire',
    4 => 'usd',
    5 => 'comment',
    6 => 'plane'
  }

  I18n.locale = user.locale if user.locale
  result = {}

  ActiveRecord::Base.transaction do
    default_sectors.each do |def_id, icon|
      result[def_id] = Sector.create(
        user: user,
        name: I18n.translate("sector.id_#{def_id}.name"),
        description: I18n.translate("sector.id_#{def_id}.description"),
        icon: icon
      )
    end
  end
  result
end