class DaysController < ApplicationController
  before_action :authenticate_user!

  # GET /days/01-01-2015
  # GET /days/01-01-2015.json
  def show
    @day = Day.new params_date
    @sectors = Sector.where(user: current_user)
    @progress = Fragment.progress_for_days([@day] + @day.previous_days)
    @subsectors = Subsector.where(sector: @sectors.map(&:id))
    @subsectors_ids = group_relation_ids_by(@subsectors, :sector_id)
    @activities = Activity.where(subsector_id: @subsectors.map(&:id)).counts_for(@day)
    @activities_ids = group_relation_ids_by(@activities, :subsector_id)

    respond_to do |format|
      format.html { render 'show' }
      format.json { render partial: 'day', status: :ok }
    end
  end

  private

  def params_date
    if !params[:date] || params[:date] == '0'
      date = nil
    elsif /(\d{2}-\d{2}-\d{4})/.match(params[:date])
      date = Date.strptime(params[:date], '%d-%m-%Y')
      if date > Date.current.end_of_day
        flash.notice = 'You can not control future, showing today'
        date = nil
      end
    else
      flash.notice = 'Invalid date parameter, showing today'
      date = nil
    end
    date || Date.current
  end

  def group_relation_ids_by(relation, field)
    relation.each_with_object(Hash.new { |h, k| h[k] = [] }) { |entry, h| h[entry[field]] << entry.id }
  end
end
