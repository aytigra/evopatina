class FragmentsController < ApplicationController
  before_action :set_activity, :set_week, only: [:update]

  # PATCH/PUT /fragments/1.json
  def update
    response_json = { id: @activity.id, subsector_id: @activity.subsector_id, sector_id: params[:sector_id] }
    fragment = Fragment.find_or_create(@activity, @week)
    fragment.count = params[:count].to_f
    if fragment.save
      SectorWeek.recount_progress(@activity.subsector.sector, @week)
      render json: response_json, status: :ok
    else
      response_json[:errors] = @activity.errors
      render json: response_json, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_week
      @week = Week.find params[:week_id]
    end

    def set_activity
      @activity = Activity.find params[:id]
    end

end
