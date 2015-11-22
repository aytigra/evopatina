class PagesController < ApplicationController

  def about
  end

  # GET /patina
  # GET /patina.json
  def patina
    sectors = Sector.where(user: current_user).load
    subsectors = Subsector.where(sector_id: sectors.map(&:id)).group_by(&:sector_id)
    activities = Activity.where(subsector_id: subsectors.values.flatten.map(&:id)).group_by(&:subsector_id)

    json_locals = { sectors: sectors, subsectors: subsectors, activities: activities }

    respond_to do |format|
      format.html { render 'patina' }
      format.json { render partial: 'patina', locals: json_locals, status: :ok }
    end
  end

end