class FragmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, :set_day, only: [:update]

  # PATCH/PUT /fragments/1.json
  def update
    sector_id = @activity.sector.id
    response_json = { id: @activity.id, subsector_id: @activity.subsector_id, sector_id: @activity.sector.id }

    fragment = Fragment.find_or_create(@activity, @day)
    fragment.count = params[:count].to_f

    if fragment.save
      render json: response_json, status: :ok
    else
      response_json[:errors] = @activity.errors
      render json: response_json, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_day
    @day = Day.find params[:day_id]
  end

  def set_activity
    @activity = Activity.find params[:id]
  end
end
