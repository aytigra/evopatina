class SubsectorsController < ApplicationController
  before_action :set_subsector, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /subsectors
  # GET /subsectors.json
  def index
    @subsectors = Subsector.all
  end

  # GET /subsectors/1
  # GET /subsectors/1.json
  def show
  end

  # GET /subsectors/new
  def new
    @subsector = Subsector.new
  end

  # GET /subsectors/1/edit
  def edit
  end

  # POST /subsectors.json
  def create
    data = subsector_params
    data[:user_id] = current_user.id
    @subsector = Subsector.new(data)
    respond_to do |format|
      if @subsector.save
        format.json { render json: response_json, status: :created }
      else
        format.json { render json: response_json, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subsectors/1.json
  def update
    respond_to do |format|
      if @subsector.update(subsector_params)
        format.json { render json: response_json, status: :ok }
      else
        format.json { render json: response_json, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subsectors/1.json
  def destroy
    respond_to do |format|
      if @subsector.destroy
        format.json { render json: response_json, status: :ok }
      else
        format.json { render json: response_json, status: :unprocessable_entity }
      end
    end
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
        old_id: params[:id].to_s.gsub(/\W/, '') }
    end
end
