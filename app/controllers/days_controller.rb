class DaysController < ApplicationController
  before_action :authenticate_user!

  # GET /days/01-01-2015
  # GET /days/01-01-2015.json
  def show
    @day = Day.new params_date
    @sectors = Sector.includes(:subsectors, :activities, :fragments)
                     .where(user: current_user)
                     .where(fragments: { week_id: [nil, @day.id] })
                     .order('sectors.position, subsectors.position, activities.position')

    @subsectors = @sectors.map(&:subsectors).flatten
    @activities = @subsectors.map(&:activities).flatten

    @json_locals = {
      day: @day,
      sectors: @sectors,
      subsectors: @subsectors,
      activities: @activities,
    }

    respond_to do |format|
      format.html { render 'show' }
      format.json { render partial: 'day', locals: @json_locals, status: :ok }
    end
  end

  private

  def lapa_params
    lapa_params = {}
    params[:lapa].each { |k, v| lapa_params[k.to_i] = v.to_f }
    lapa_params
  end

  def params_date
    if !params[:date] || params[:date] == '0'
      date = nil
    elsif /(\d{2}-\d{2}-\d{4})/.match(params[:date])
      date = Date.strptime(params[:date], '%d-%m-%Y')
      if date > Date.current.end_of_day
        flash.notice = 'You can not control future, showing today'
        date = nil
      end
    else
      flash.notice = 'Invalid date parameter, showing today'
      date = nil
    end
    date || Date.current
  end

  def group_relation_ids_by(relation, field)
    relation.each_with_object(Hash.new { |h, k| h[k] = [] }) { |entry, h| h[entry[field]] << entry.id }
  end
end
