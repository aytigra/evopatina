class WeeksController < ApplicationController
  before_action :authenticate_user!
  before_action :init_current_week, only: [:index]

  def index
    @current_week = init_current_week
    @weeks = Week.where(user: current_user).by_date.limit(10)
  end

  # GET /weeks/1
  # GET /weeks/1.json
  def show
    @current_week = Week.find_by_id(url_id)
    @weeks = Week.where(user: current_user).by_date.limit(10)
    #prev_week = Time.zone.now.beginning_of_week - 1.week
    #Week.create(date: prev_week, lapa: @current_week.lapa, progress: Sector.hash, user: current_user)
    render 'index'
  end

  def init_current_week
    @current_week_start = Time.zone.now.beginning_of_week
    @current_week = Week.last_week(current_user)
    if @current_week.date != @current_week_start
      @current_week = Week.create(date: @current_week_start, lapa: @current_week.lapa, progress: Sector.hash, user: current_user)
    end
    @current_week
  end

  def update_lapa
    input = lapa_params
    week = Week.find_by_id(input[:id])
    week.lapa = Sector.hash input[:lapa] if week
    respond_to do |format|
      if week && week.save
        format.html { redirect_to root_path }
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
