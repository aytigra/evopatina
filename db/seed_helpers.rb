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

def populate_users_with_default_sectors(users)
  users.each do |user|
    weeks = Week.where(user_id: user.id)
    create_default_sectors_for_user(user).each do |old_id, sector|
      #relate subsectors to new sectors
      Subsector.where(user_id: user.id, sector_id: old_id).update_all(sector_id: sector.id)

      #fill new sector weeks relation with data from week hashes(lapa, progress)
      ActiveRecord::Base.transaction do
        weeks.each do |week|
          SectorWeek.new do |sw|
            sw.sector    = sector
            sw.week      = week
            sw.lapa      = week.lapa[old_id] || 0.0
            sw.progress  = week.progress[old_id] || 0.0
            sw.save
          end
        end
      end
    end
  end
end