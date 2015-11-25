class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:update, :destroy, :move]
  before_action :authenticate_user!
  before_action :set_default_response_format

  # GET /activities.json
  def index
    @activities = Activity.all
  end

  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)
    render_response @activity.save
  end

  # PATCH/PUT /activities/1.json
  def update
    render_response @activity.update(activity_params)
  end

  # DELETE /activities/1.json
  def destroy
    render_response @activity.destroy
  end

  # PUT /move_activity/1.json
  def move
    case params[:to]
    when 'up'
      @activity.row_order_position = :up
    when 'down'
      @activity.row_order_position = :down
    when 'subsector'
      @activity.subsector_id = params[:subsector_id].to_i
      @activity.row_order_position = :last
    end
    render_response @activity.save
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

    def response_json
      { id: @activity.id, errors: @activity.errors.full_messages, subsector_id: @activity.subsector_id,
        sector_id: params[:sector_id].to_i, old_id: params[:id].to_s.gsub(/\W/, '') }
    end

    def render_response(status_ok)
      status = status_ok ? :ok : :unprocessable_entity
      render json: response_json, status: status
    end

    def set_default_response_format
      request.format = :json
    end

end
