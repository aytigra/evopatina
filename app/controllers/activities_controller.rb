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
    respond_to do |format|
      if @activity.save
        format.json { render json: response_json, status: :created }
      else
        format.json { render json: response_json, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.json { render json: response_json, status: :ok }
      else
        format.json { render json: response_json, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1.json
  def destroy
    respond_to do |format|
      if @activity.destroy
        format.json { render json: response_json, status: :ok }
      else
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

    def response_json
      { id: @activity.id, errors: @activity.errors, subsector_id: @activity.subsector_id, 
        sector_id: params[:sector_id].to_i, old_id: params[:id].to_s.gsub(/\W/, '') }
    end


end
