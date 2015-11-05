class WeeksController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  # GET /weeks/01-01-2015
  # GET /weeks/01-01-2015.json
  def show
    @week = Week.get_week current_user, params_date
    @weeks = [@week] + @week.previous_weeks
    @sectors = Sector.sectors_with_weeks(current_user, @weeks)
    @subsectors = Subsector.subsectors_by_sectors(current_user)
    @activities = Activity.activities_by_subsectors(current_user, @week)

    @prev_week_path = week_path(@weeks[1])
    @next_week_path = week_path(Week.new(date: @week.date + 1.week)) if @week.date < Date.current.beginning_of_week
    @json_locals = { week: @week, sectors: @sectors, subsectors: @subsectors, activities: @activities }
    #debug
    respond_to do |format|
      format.html { render 'show' }
      format.json { render partial: 'week', locals: @json_locals, status: :ok }
    end
  end

  # PATCH /weeks/1.json
  def update
    week = Week.find params[:id]
    lapa_params.each do |sector_id, lapa|
      SectorWeek.find_or_initialize_by(sector_id: sector_id, week: week).update(lapa: lapa)
    end

    format.json { render json: {}, status: :ok }
  end

  private

  def lapa_params
    lapa_params = {}
    params[:week][:lapa].each { |k,v| lapa_params[k.to_i] = v.to_f}
    lapa_params
  end

  def params_date
    if !params[:date] || params[:date] == '0'
      date = nil
    elsif /(\d{2}-\d{2}-\d{4})/.match(params[:date])
      date = Date.strptime(params[:date], '%d-%m-%Y').beginning_of_week
      if date > Date.current.end_of_week
        flash.notice = 'I can not control future, showing current week'
        date = nil
      end
    else
      flash.notice = 'Invalid date parameter, showing current week'
      date = nil
    end
    date ||= Date.current.beginning_of_week
  end

end
