class ChangeSectorsIcons < ActiveRecord::Migration
  def up
    Sector.where(icon: 'compressed').update_all(icon: '💪')
    Sector.where(icon: 'education').update_all(icon: '🎓')
    Sector.where(icon: 'fire').update_all(icon: '😊')
    Sector.where(icon: 'usd').update_all(icon: '💰')
    Sector.where(icon: 'comment').update_all(icon: '💬')
    Sector.where(icon: 'plane').update_all(icon: '✈')
  end

  def down
    Sector.where(icon: '💪').update_all(icon: 'compressed')
    Sector.where(icon: '🎓').update_all(icon: 'education')
    Sector.where(icon: '😊').update_all(icon: 'fire')
    Sector.where(icon: '💰').update_all(icon: 'usd')
    Sector.where(icon: '💬').update_all(icon: 'comment')
    Sector.where(icon: '✈').update_all(icon: 'plane')
  end
end
