class SectorsController < ApplicationController
  before_action :set_sector, only: [:update, :destroy, :move]
  before_action :authenticate_user!
  before_action :set_default_response_format

  # POST /sectors.json
  def create
    data = sector_params
    data[:user_id] = current_user.id
    @sector = Sector.new(data)
    render_response @sector.save
  end

  # PATCH/PUT /sectors/1.json
  def update
    render_response @sector.update(sector_params)
  end

  # DELETE /sectors/1.json
  def destroy
    render_response @sector.destroy
  end

  # PUT /move_sectors/1.json
  def move
    case params[:to]
    when 'up'
      @sector.row_order_position = :up
    when 'down'
      @sector.row_order_position = :down
    end
    render_response @sector.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sector
      @sector = Sector.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sector_params
      params.require(:sector).permit(:name, :description, :icon, :color)
    end

    def response_json
      { id: @sector.id, errors: @sector.errors,
        old_id: params[:id].to_s.gsub(/\W/, ''), position: @sector.position }
    end

    def render_response(status_ok)
      status = status_ok ? :ok : :unprocessable_entity
      render json: response_json, status: status
    end

    def set_default_response_format
      request.format = :json
    end
end