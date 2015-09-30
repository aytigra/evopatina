class FragmentsController < ApplicationController
  before_action :set_activity, :set_week, only: [:update]

  # PATCH/PUT /fragments/1.json
  def update
    sector_id = params[:sector_id].to_i
    response_json = { id: @activity.id, subsector_id: @activity.subsector_id, sector_id: sector_id }
    if sector_id > 0
      fragment = Fragment.find_or_create(@activity, @week)
      old_count = fragment.count || 0.0
      fragment.count = params[:count].to_f
      if fragment.save
        @week.progress[sector_id] = @week.progress[sector_id] + fragment.count - old_count
        @week.save
        render json: response_json, status: :ok
      else
        response_json[:errors] = @activity.errors
        render json: response_json, status: :unprocessable_entity
      end
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
