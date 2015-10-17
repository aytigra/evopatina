class SubsectorsController < ApplicationController
  before_action :set_subsector, only: [:update, :destroy, :move]
  before_action :authenticate_user!
  before_action :set_default_response_format

  # GET /subsectors
  # GET /subsectors.json
  def index
    @subsectors = Subsector.all
  end

  # POST /subsectors.json
  def create
    data = subsector_params
    data[:user_id] = current_user.id
    @subsector = Subsector.new(data)
    render_response @subsector.save
  end

  # PATCH/PUT /subsectors/1.json
  def update
    render_response @subsector.update(subsector_params)
  end

  # DELETE /subsectors/1.json
  def destroy
    render_response @subsector.destroy
  end

  # PUT /move_subsectors/1.json
  def move
    status_ok = true
    case params[:to]
    when 'up'
      @subsector.row_order_position = :up
    when 'down'
      @subsector.row_order_position = :down
    when 'sector'
      @subsector.sector_id = params[:sector_id].to_i
      @subsector.row_order_position = :last
    end
    status_ok = @subsector.save
    render_response status_ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subsector
      @subsector = Subsector.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subsector_params
      params.require(:subsector).permit(:sector_id, :name, :description)
    end

    def response_json
      { id: @subsector.id, sector_id: @subsector.sector_id, errors: @subsector.errors,
        old_id: params[:id].to_s.gsub(/\W/, ''), position: @subsector.position }
    end

    def render_response(status_ok)
      status = status_ok ? :ok : :unprocessable_entity
      render json: response_json, status: status
    end

    def set_default_response_format
      request.format = :json
    end
end
