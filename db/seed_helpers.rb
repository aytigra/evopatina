# users - array of users to populate

def populate_users_with_default_sectors(users)
  default_sectors = [1,2,3,4,5,6]

  default_icons = {
    1 => 'compressed',
    2 => 'education',
    3 => 'fire',
    4 => 'usd',
    5 => 'comment',
    6 => 'plane'
  }

  users.each do |user|
    I18n.locale = user.locale

    weeks = Week.where(user_id: user.id)

    default_sectors.each do |def_id|

      sector = Sector.new do |s|
        s.user        = user
        s.name        = I18n.translate("sector.id_#{def_id}.name")
        s.description = I18n.translate("sector.id_#{def_id}.description")
        s.icon        = default_icons[def_id]
        s.position    = def_id
        s.save
      end

      #relate subsectors to new sectors
      Subsector.where(user_id: user.id, sector_id: def_id).update_all(sector_id: sector.id)

      #fill new sector weeks relation with data from week hashes(lapa, progress)
      weeks.each do |week|
        SectorWeek.new do |sw|
          sw.sector    = sector
          sw.week      = week
          sw.lapa      = week.lapa[def_id] || 0.0
          sw.progress  = week.progress[def_id] || 0.0
          sw.save
        end
      end

    end

  end
end