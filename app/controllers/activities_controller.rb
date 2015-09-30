class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /activities
  # GET /activities.json
  def index
    @activities = Activity.all
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)
    response_json = { subsector_id: @activity.subsector_id, old_id: response_params[:old_id], sector_id: response_params[:sector_id] }
    respond_to do |format|
      if @activity.save
        response_json[:id] = @activity.id
        format.json { render json: response_json, status: :created }
      else
        response_json[:errors] = @activity.errors
        format.json { render json: response_json, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      response_json = { id: @activity.id, subsector_id: @activity.subsector_id, sector_id: response_params[:sector_id] }
      if @activity.update(activity_params)
        update_fragments
        format.json { render json: response_json, status: :ok }
      else
        response_json[:errors] = @activity.errors
        format.json { render json: response_json, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1.json
  def destroy
    respond_to do |format|
      response_json = { id: @activity.id, subsector_id: @activity.subsector_id, sector_id: response_params[:sector_id] }
      if @activity.destroy
        format.json { render json: response_json, status: :ok }
      else
        response_json[:errors] = @activity.errors
        format.json { render json: response_json, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      par = params.require(:activity).permit(:subsector_id, :name, :description, :hidden)
    end

    def response_params
      { sector_id: params[:sector_id].to_i, old_id: params[:id].to_s.gsub(/\W/, '') }
    end

    def fragments_params
      { count: params[:count].to_f, week_id: params[:week_id].to_i, sector_id: params[:sector_id].to_i }
    end

    def update_fragments
      input = fragments_params
      if input[:sector_id] > 0 && week = Week.find_by_id(input[:week_id]) 
        fragments = Fragment.find_or_create(@activity, week)
        old_count = fragments.count || 0.0
        fragments.count = input[:count]
        if fragments.save
          week.progress[input[:sector_id]] = week.progress[input[:sector_id]] + fragments.count - old_count
          week.save
        end
      end
    end
end
