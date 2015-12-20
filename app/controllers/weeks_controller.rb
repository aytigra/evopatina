class WeeksController < ApplicationController
  before_action :authenticate_user!

  # GET /weeks/01-01-2015
  # GET /weeks/01-01-2015.json
  def show
    @week = Week.get_week params_date
    @weeks = [@week] + @week.previous_weeks
    @sectors = Sector.sectors_with_weeks(current_user, @weeks)
    @subsectors = Subsector.where_sectors @sectors
    @activities = Activity.with_fragments_count(@subsectors, @week)

    @json_locals = {
      week: @week,
      weeks: @weeks,
      sectors: @sectors,
      subsectors: @subsectors,
      activities: @activities,
      subsectors_ids: group_relation_ids_by(@subsectors, :sector_id),
      activities_ids: group_relation_ids_by(@activities, :subsector_id)
    }

    respond_to do |format|
      format.html { render 'show' }
      format.json { render partial: 'week', locals: @json_locals, status: :ok }
    end
  end

  # PATCH /weeks/1.json
  def update
    week = Week.find params[:id]
    lapa_params.each do |sector_id, lapa|
      SectorWeek.find_or_initialize_by(sector_id: sector_id, week_id: week.id).update(lapa: lapa)
    end

    render json: {}, status: :ok
  end

  private

  def lapa_params
    lapa_params = {}
    params[:lapa].each { |k, v| lapa_params[k.to_i] = v.to_f }
    lapa_params
  end

  def params_date
    if !params[:date] || params[:date] == '0'
      date = nil
    elsif /(\d{2}-\d{2}-\d{4})/.match(params[:date])
      date = Date.strptime(params[:date], '%d-%m-%Y')
      if date > Date.current.end_of_week
        flash.notice = 'You can not control future, will show current week'
        date = nil
      end
    else
      flash.notice = 'Invalid date parameter, will show current week'
      date = nil
    end
    date || Date.current
  end

  def group_relation_ids_by(relation, field)
    relation.each_with_object(Hash.new { |h, k| h[k] = [] }) { |entry, h| h[entry[field]] << entry.id }
  end
end
