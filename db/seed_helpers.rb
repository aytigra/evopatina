def default_sectors
  {
    1 => '💪',
    2 => '🎓',
    3 => '😊',
    4 => '💰',
    5 => '🐧',
    6 => '🎡',
    7 => '🔬',
    8 => '🎹'
  }
end

def create_default_sectors_for_user(user)
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
