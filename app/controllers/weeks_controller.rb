class WeeksController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  # GET /weeks/1
  # GET /weeks/1.json
  def show
    @week = Week.get_week current_user, params_date
    @weeks = [@week] + @week.previous_weeks
    @sectors = Sector.where(user: current_user)
    @subsectors = Subsector.subsectors_by_sectors(current_user)
    @activities = Activity.activities_by_subsectors(current_user, @week)
    @sector_weeks = SectorWeek.sector_weeks_by_sectors(@sectors, @weeks)
    @json_locals = { week: @week, sectors: @sectors, subsectors: @subsectors, activities: @activities }

    respond_to do |format|
      format.html { render 'show' }
      format.json { render partial: 'week', locals: @json_locals, status: :ok }
    end
  end

  def init_current_week(week = nil)

    #@current_week.recount_progress.save

    # find sums of lapas and progresses by last 4 weeks
    # starting from last week
    # lapa_sum = {}
    # progress_sum = {}
    # (0..@weeks.length-1).reverse_each do |i|
    #   @sectors.each do |sector|
    #     lapa_sum[sector.id] ||= 0
    #     progress_sum[sector.id] ||= 0
    #     lapa_sum[sector.id] += @sector_weeks[sector.id][@weeks[i].id][:lapa]
    #     progress_sum[sector.id] += @sector_weeks[sector.id][@weeks[i].id][:progress]
    #     if i+4 < @weeks.length #if not out of range
    #       lapa_sum[sector.id] -= @sector_weeks[sector.id][@weeks[i+4].id][:lapa]
    #       progress_sum[sector.id] -= @sector_weeks[sector.id][@weeks[i+4].id][:progress]
    #     end
    #   end
    #   @weeks[i].lapa_sum = lapa_sum.clone
    #   @weeks[i].progress_sum = progress_sum.clone
    #   #hmm
    #   if @weeks[i].id == @current_week.id
    #     @current_week = @weeks[i]
    #   end
    # end
    #debug
  end

  def update
    week = Week.find_by_id(url_id)
    week.lapa = Sector.hash lapa_params if week
    respond_to do |format|
      if week && week.save
        format.html { redirect_to :back }
      else
        format.html { redirect_to root_path, notice: 'wrong lapa'}
      end
    end
  end

  private

  def lapa_params
    lapa_params = {}
    params[:week][:lapa].each { |k,v| lapa_params[k.to_i] = v.to_f}
    lapa_params
  end

  def url_id
    params[:id].to_i
  end

  def params_date
    begin
      params[:date].to_s.to_date.at_beginning_of_week
    rescue
      notice = 'unexpected date parameter, open current week' if params[:date]
      Date.today.at_beginning_of_week
    end
  end

end
