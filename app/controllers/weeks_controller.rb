class WeeksController < ApplicationController
  before_action :authenticate_user!

  def index
    init_current_week
  end

  # GET /weeks/1
  # GET /weeks/1.json
  def show
    week = Week.find_by_id(url_id)

    respond_to do |format|
      if week
        init_current_week(week)
        #prev_week = week.date - 1.week
        #Week.create(date: prev_week, lapa: @current_week.lapa, progress: Sector.hash, user: current_user)
        format.html { render 'index' }
      else
        format.html { redirect_to root_path, notice: 'wrong week'}
      end
    end
  end

  def init_current_week(week = nil)
    if week
      @current_week = week
    else
      @current_week = Week.last_week(current_user)
    end
    @current_week.recount_progress.save
    make_prev_week(@current_week)
    @after_weeks = Week.where(user: current_user).where('date >= ?', @current_week.date).by_date.limit(5)
    after_weeks_count = @after_weeks.length
    @before_weeks = Week.where(user: current_user).where('date < ?', @current_week.date).by_date.limit(10 - after_weeks_count)
    @weeks = @after_weeks + @before_weeks
    @next_week = nil
    @next_week = @after_weeks[after_weeks_count - 2] if after_weeks_count >= 2
    @prev_week = @before_weeks[0]

    @sectors = Sector.all
    @subsectors = Subsector.subsectors_by_sectors(current_user)
    @activities = Activity.activities_by_subsectors(current_user, @current_week)
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

  def make_prev_week(current_week)
    prew_week_date = (current_week.date - 1.week).at_beginning_of_week
    prev_week = Week.where(user: current_user, date: prew_week_date).limit(1).first rescue nil
    if prev_week == nil
      lapa = prev_week == nil ? Sector.hash : current_week.lapa
      prev_week = Week.create(date: prew_week_date, lapa: lapa, progress: Sector.hash, user: current_user)
    end
    prev_week
  end

end
