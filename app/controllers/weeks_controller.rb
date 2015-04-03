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
      current_week_start = Time.zone.now.beginning_of_week.to_date
      @current_week = Week.last_week(current_user)
      if @current_week.date != current_week_start
        @current_week = Week.create(date: current_week_start, lapa: @current_week.lapa, progress: Sector.hash, user: current_user)
      end
    end
    @after_weeks = Week.where(user: current_user).where('date >= ?', @current_week.date).by_date.limit(5)
    after_weeks_count = @after_weeks.length
    @before_weeks = Week.where(user: current_user).where('date < ?', @current_week.date).by_date.limit(10 - after_weeks_count)
    @weeks = @after_weeks + @before_weeks 
    @next_week = nil
    @next_week = @after_weeks[after_weeks_count - 2] if after_weeks_count >= 2
    @prev_week = @before_weeks[0]
  end

  def update_lapa
    input = lapa_params
    week = Week.find_by_id(input[:id])
    week.lapa = Sector.hash input[:lapa] if week
    respond_to do |format|
      if week && week.save
        format.html { redirect_to :back }
      else
        format.html { redirect_to root_path, notice: 'wrong lapa'}
      end
    end
  end

  def lapa_params
    lapa_params = {lapa: {}, id: 0}
    params[:week][:lapa].each { |k,v| lapa_params[:lapa][k.to_i] = v.to_f}
    lapa_params[:id] = params[:week][:id].to_i
    lapa_params
  end

  def url_id
    params[:id].to_i
  end
end
