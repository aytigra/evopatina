class WeeksController < ApplicationController
  before_action :authenticate_user!

  def index
    init_current_week
  end

  # GET /weeks/1
  # GET /weeks/1.json
  def show
    week = Week.find_by_id(url_id)
    init_current_week(week)

    respond_to do |format|
      format.html { render 'index' }
      locals = { week: @current_week, sectors: @sectors, subsectors: @subsectors, activities: @activities }
      format.json { render partial: 'week', locals: locals, status: :ok }
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
    @after_weeks = Week.where(user: current_user).where('date >= ?', @current_week.date).by_rev_date.limit(5).reverse
    after_weeks_count = @after_weeks.length
    @before_weeks = Week.where(user: current_user).where('date < ?', @current_week.date).by_date.limit(10 - after_weeks_count)
    @weeks = @after_weeks + @before_weeks
    @next_week = @after_weeks[after_weeks_count - 2] if after_weeks_count >= 2
    @prev_week = @before_weeks[0]
    @sectors = Sector.all
    @subsectors = Subsector.subsectors_by_sectors(current_user)
    @activities = Activity.activities_by_subsectors(current_user, @current_week)

    #find sums of lapas and progresses by last 4 weeks
    #starting from last week
    lapa_sum = Sector.hash
    progress_sum = Sector.hash
    (0..@weeks.length-1).reverse_each do |i|
      Sector.keys.each do |s|
        lapa_sum[s] += @weeks[i].lapa[s]
        progress_sum[s] += @weeks[i].progress[s]
        if i+4 < @weeks.length #if not out of range
          lapa_sum[s] -= @weeks[i+4].lapa[s]
          progress_sum[s] -= @weeks[i+4].progress[s]
        end
      end
      @weeks[i].lapa_sum = lapa_sum.clone
      @weeks[i].progress_sum = progress_sum.clone
      #hmm
      if @weeks[i].id == @current_week.id
        @current_week = @weeks[i]
      end
    end
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

  def make_prev_week(current_week)
    prew_week_date = (current_week.date - 1.week).at_beginning_of_week
    prev_week = Week.where(user: current_user, date: prew_week_date).first_or_create do |pw|
      pw.lapa = current_week.lapa
      pw.progress = Sector.hash
    end
  end

end
