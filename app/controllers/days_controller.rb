class DaysController < ApplicationController
  before_action :authenticate_user!

  # GET /days/01-01-2015
  # GET /days/01-01-2015.json
  def show
    @day = Day.new params_date
    @days = ([@day] + @day.previous_days).map(&:id).reverse
    @sectors = Sector.where(user: current_user)
    @sectors_ids = @sectors.map(&:id)
    @progress = Fragment.progress_for_days(@days, @sectors_ids)
    @subsectors = Subsector.where(sector: @sectors_ids)
    @subsectors_ids = group_relation_ids_by(@subsectors, :sector_id)
    @activities = Activity.where(subsector_id: @subsectors.map(&:id)).counts_for(@day)
    @activities_ids = group_relation_ids_by(@activities, :subsector_id)

    respond_to do |format|
      format.html { render 'show' }
      format.json { render partial: 'day', status: :ok }
    end
  end

  def summary
    @day = Day.new params_date
    @days = ([@day] + @day.previous_days)
    @subsectors = Subsector.where(sector: Sector.where(user: current_user))
    @fragments = Fragment.includes(activity: { subsector: :sector })
                         .where(day_id: @days.map(&:id), activities: { subsector_id: @subsectors })
                         .where.not(count: 0)
                         .group_by(&:day_id)

    next_day = Day.new(@day.date + @days.length.day)
    @next_link = next_day.date >= Date.current.beginning_of_day ? "/summary/" : "/summary/#{next_day.to_param}"

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
