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
    activity_json = { subsector_id: @activity.subsector_id, old_id: activity_params_id }
    respond_to do |format|
      if @activity.save
        activity_json[:id] = @activity.id
        format.json { render json: activity_json, status: :created }
      else
        activity_json[:errors] = @activity.errors
        format.json { render json: activity_json, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      activity_json = { id: @activity.id, subsector_id: @activity.subsector_id }
      if @activity.update(activity_params)
        update_fragments
        format.json { render json: activity_json, status: :ok }
      else
        activity_json[:errors] = @activity.errors
        format.json { render json: activity_json, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1.json
  def destroy
    respond_to do |format|
      activity_json = { id: @activity.id, subsector_id: @activity.subsector_id }
      if @activity.destroy
        format.json { render json: activity_json, status: :ok }
      else
        activity_json[:errors] = @activity.errors
        format.json { render json: activity_json, status: :unprocessable_entity }
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
      params.require(:activity).permit(:subsector_id, :name, :description)
    end

    def activity_params_id
      params[:id]
    end

    def fragments_params
      {fragments: params[:fragments].to_i, add_fragments: params[:add_fragments].to_i}
    end

    def update_fragments
      input = fragments_params
      if input[:fragments] > 0 || input[:add_fragments] > 0
        fragment = Fragment.find_or_create(@activity, Week.last_week(current_user))
        fragment.count = input[:add_fragments] + (input[:fragments] > 0 ? input[:fragments] : fragment.count)
        fragment.save
      end
    end
end
